import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class QuestionPaperGeneratorScreen extends StatefulWidget {
  const QuestionPaperGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<QuestionPaperGeneratorScreen> createState() =>
      _QuestionPaperGeneratorScreenState();
}

class _QuestionPaperGeneratorScreenState
    extends State<QuestionPaperGeneratorScreen> {
  File? _selectedFile;
  bool _isGenerating = false;
  String? _generatedQuestions;
  String _errorMessage = '';

  // Question configuration
  final TextEditingController _shortQuestionCountController =
      TextEditingController(text: '8');
  final TextEditingController _shortQuestionMarksController =
      TextEditingController(text: '3');
  final TextEditingController _longQuestionCountController =
      TextEditingController(text: '4');
  final TextEditingController _longQuestionMarksController =
      TextEditingController(text: '12');

  int get _shortQuestionCount =>
      int.tryParse(_shortQuestionCountController.text) ?? 8;
  int get _shortQuestionMarks =>
      int.tryParse(_shortQuestionMarksController.text) ?? 3;
  int get _longQuestionCount =>
      int.tryParse(_longQuestionCountController.text) ?? 4;
  int get _longQuestionMarks =>
      int.tryParse(_longQuestionMarksController.text) ?? 12;

  @override
  void dispose() {
    _shortQuestionCountController.dispose();
    _shortQuestionMarksController.dispose();
    _longQuestionCountController.dispose();
    _longQuestionMarksController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _generatedQuestions = null;
        _errorMessage = '';
      });
    }
  }

  Future<void> _generateQuestionPaper() async {
    if (_selectedFile == null) {
      setState(() {
        _errorMessage = 'Please select a PDF file first';
      });
      return;
    }

    setState(() {
      _isGenerating = true;
      _errorMessage = '';
      _generatedQuestions = null;
    });

    try {
      // Create a temporary directory to store our files
      final tempDir = await getTemporaryDirectory();
      final workingDir = Directory('${tempDir.path}/question_generator');

      if (await workingDir.exists()) {
        await workingDir.delete(recursive: true);
      }
      await workingDir.create();

      // Copy the PDF to the working directory
      final pdfFile = File('${workingDir.path}/test.pdf');
      await _selectedFile!.copy(pdfFile.path);

      // Create the Python script with variables at the top
      final scriptFile = File('${workingDir.path}/generate_questions.py');
      await scriptFile.writeAsString('''
from langchain_community.document_loaders import PyPDFLoader
from typing_extensions import TypedDict
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.messages import HumanMessage, SystemMessage, AnyMessage
from langgraph.graph import StateGraph, END
from langgraph.graph.message import add_messages
from typing import Annotated

# Configuration values from Flutter
short_question_count = ${_shortQuestionCount}
short_question_marks = ${_shortQuestionMarks}
long_question_count = ${_longQuestionCount}
long_question_marks = ${_longQuestionMarks}

filepath = "test.pdf"
loader = PyPDFLoader(filepath)
documents = loader.load()

llm = ChatGoogleGenerativeAI(
    model="gemini-2.0-flash-001",
    api_key=
)

class Syllabus(TypedDict):
    pdf_content: str
    modules: list[str]

class Agent:
    def __init__(self, llm):
        self.gemini = llm
        graph = StateGraph(Syllabus)
        graph.add_node("start", self.split_question)
        graph.add_node("question", self.create_question)
        graph.add_edge("start", "question")
        graph.set_entry_point("start")
        graph.add_edge("question", END)

        self.questions = {}

        self.graph = graph.compile()

    def split_question(self, state):
        full_text = state['pdf_content']
        prompt = f"""
        Analyze the following text and split it into Modules.
        Each Module should have a title and the content of the module.
        The title should be a single line and the content should be the rest of the text.
        Each module should be separated by a 2 newlines.
        the text is:
        {full_text}
        """
        
        response = self.llm(prompt)
        data = response.content.split("\\n\\n")
        return {'modules': data}
    
    def create_question(self, state):
        modules = state['modules']
        for i, module in enumerate(modules):
            prompt = f"""
            You are an experienced teacher. You are good at preparing a question paper for examination.
            You will be a given a module and its topic. Your task is to prepare a question paper for the module.
            The Questions should cover the whole syllabus of the module.
            The questions should be divided in this format:
            {short_question_count} questions of {short_question_marks} marks each, only print {short_question_count} questions
            {long_question_count} questions of {long_question_marks} marks each divided into 2 sections with one as an or question.
            for each question print the bloom taxonomy level from l1,l2,l3,l4,l5,l6 of the question on the right hand side of the question.
            also add the cognitive level of the question on the right hand side of the question.
            The cognitive level should be one of the following: Remembering, Understanding, Applying, Analyzing, Evaluating, Creating as c01, c02, c03, c04, c05, c06.
            both the levels should be enclosed in a square bracket. separated by a comma.
            Only write the questions and do not write any explanation or anything else. and no introduction stuff.
            what ever the module be only print the subject name dont print the module name.
            The module content is:
            {module}
            """
            response = self.llm(prompt)
            self.questions[i] = response.content


    def llm(self, prompt):
        if not isinstance(prompt, (dict, str)) and hasattr(prompt, 'content'):
            message = prompt
        else:
            message = HumanMessage(content=str(prompt))
        
        return self.gemini.invoke([message])
    
agent = Agent(llm)
content = documents[0].page_content

result = agent.graph.invoke({'pdf_content': content})
# Print the first module's questions
print(agent.questions[5])
''');

      // Run the Python script using Dart's Process class
      final process = await Process.run(
        'python',
        [scriptFile.path],
        workingDirectory: workingDir.path,
      );

      if (process.exitCode == 0) {
        setState(() {
          _isGenerating = false;
          _generatedQuestions = process.stdout.toString();
        });
      } else {
        setState(() {
          _isGenerating = false;
          _errorMessage = 'Error running Python script: ${process.stderr}';
        });
      }
    } catch (e) {
      setState(() {
        _isGenerating = false;
        _errorMessage = 'Error generating questions: $e';
      });
    }
  }

  // New method to export the generated questions to PDF
  Future<void> _exportToPdf() async {
    if (_generatedQuestions == null || _generatedQuestions!.isEmpty) {
      setState(() {
        _errorMessage =
            'No questions to export. Please generate questions first.';
      });
      return;
    }

    try {
      // Create a PDF document
      final pdf = pw.Document();

      // Add a page with the questions
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          header: (pw.Context context) {
            return pw.Container(
              alignment: pw.Alignment.center,
              margin: const pw.EdgeInsets.only(bottom: 20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'QUESTION PAPER',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Generated by Mentora',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Divider(),
                ],
              ),
            );
          },
          footer: (pw.Context context) {
            return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 10),
              child: pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: const pw.TextStyle(
                  fontSize: 10,
                ),
              ),
            );
          },
          build: (pw.Context context) {
            // Split the text into lines for better formatting
            final lines = _generatedQuestions!.split('\n');

            // Create text widgets for each line
            return [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: lines.map((line) {
                  // If line contains a bloom taxonomy level marker [L1, c01]
                  if (line.contains('[L') && line.contains('c0')) {
                    // Split the line to separate the question from the taxonomy level
                    final parts = line.split('[');
                    final question = parts[0].trim();
                    final taxonomy = '[${parts[1]}';

                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 8),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Text(question),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Text(
                            taxonomy,
                            style: pw.TextStyle(
                              fontStyle: pw.FontStyle.italic,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // If it's a section header (bold)
                  else if (line.startsWith('**') && line.endsWith(':**')) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 12),
                      child: pw.Text(
                        line.replaceAll('**', ''),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
                  // Regular line
                  else {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 8),
                      child: pw.Text(line),
                    );
                  }
                }).toList(),
              ),
            ];
          },
        ),
      );

      // Show save file dialog
      final output = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Question Paper',
        fileName: 'question_paper.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (output != null) {
        // Save the PDF to the selected location
        final file = File(output);
        await file.writeAsBytes(await pdf.save());

        // Show success message
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Question paper exported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error exporting to PDF: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Paper Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File Selection
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Syllabus PDF'),
                  onPressed: _pickFile,
                ),
                const SizedBox(width: 16),
                if (_selectedFile != null)
                  Expanded(
                    child: Text(
                      'Selected: ${_selectedFile!.path.split('/').last}',
                      style: const TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Question Configuration
            const Text(
              'Question Paper Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Short Questions
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('Short Questions:'),
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    decoration: const InputDecoration(
                      labelText: 'Count',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: _shortQuestionCountController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextField(
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    decoration: const InputDecoration(
                      labelText: 'Marks each',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: _shortQuestionMarksController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Long Questions
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('Long Questions:'),
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    decoration: const InputDecoration(
                      labelText: 'Count',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: _longQuestionCountController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextField(
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    decoration: const InputDecoration(
                      labelText: 'Marks each',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: _longQuestionMarksController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Generate Button
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isGenerating ? null : _generateQuestionPaper,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007ACC),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: _isGenerating
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Generating...'),
                            ],
                          )
                        : const Text(
                            'Generate Question Paper',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                  ),

                  // Add Export to PDF button
                  if (_generatedQuestions != null) ...[
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.picture_as_pdf,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      label: const Text('Export to PDF',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255))),
                      onPressed: _exportToPdf,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 49, 107, 255),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Generated Questions
            if (_generatedQuestions != null) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Generated Question Paper',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    border: Border.all(color: const Color(0xFF333333)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      _generatedQuestions!,
                      style: const TextStyle(
                        fontFamily: 'Consolas, monospace',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
