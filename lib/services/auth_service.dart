// lib/services/auth_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get error => _error;

  // Initialize and check if user is already logged in
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('currentUser');

      if (userJson != null) {
        _currentUser = User.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      _error = 'Failed to initialize: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register a new user
  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if users list exists
      List<String> usersJsonList = prefs.getStringList('users') ?? [];

      // Check if username or email already exists
      for (var userJson in usersJsonList) {
        final user = User.fromJson(jsonDecode(userJson));
        if (user.username == username) {
          _error = 'Username already exists';
          _isLoading = false;
          notifyListeners();
          return false;
        }
        if (user.email == email) {
          _error = 'Email already exists';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      // Create new user
      final newUser = User(
        username: username,
        email: email,
        password: password,
      );

      // Add to users list
      usersJsonList.add(jsonEncode(newUser.toJson()));
      await prefs.setStringList('users', usersJsonList);

      // Set as current user
      _currentUser = newUser;
      await prefs.setString('currentUser', jsonEncode(newUser.toJson()));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Registration failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Get users list
      List<String> usersJsonList = prefs.getStringList('users') ?? [];

      // Find matching user
      for (var userJson in usersJsonList) {
        final user = User.fromJson(jsonDecode(userJson));
        if ((user.username == username || user.email == username) &&
            user.password == password) {
          // Set as current user
          _currentUser = user;
          await prefs.setString('currentUser', jsonEncode(user.toJson()));

          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      // No matching user found
      _error = 'Invalid username or password';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUser');
      _currentUser = null;
    } catch (e) {
      _error = 'Logout failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
