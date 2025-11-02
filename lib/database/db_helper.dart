import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  // 🔹 Cambia el nombre de la base para crear una nueva y evitar errores de caché
  static const _databaseName = "mynotes_v2.db";
  static const _databaseVersion = 1;

  static Database? _database;

  // ================= OBTENER BASE DE DATOS =================
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // ================= INICIALIZAR BASE =================
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // ================= CREAR TABLAS Y DATOS =================
  Future<void> _onCreate(Database db, int version) async {
    // ======== TABLA DE USUARIOS (Admin y Profesores) ========
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT NOT NULL UNIQUE,
        contrasena TEXT NOT NULL,
        rol TEXT NOT NULL
      )
    ''');

    // ======== USUARIOS POR DEFECTO ========
    await db.insert('usuarios', {
      'nombre': 'Administrador',
      'correo': 'admin@escuela.com',
      'contrasena': 'admin123',
      'rol': 'admin',
    });

    await db.insert('usuarios', {
      'nombre': 'Profesor Juan',
      'correo': 'juan@escuela.com',
      'contrasena': 'juan123',
      'rol': 'profesor',
    });

    await db.insert('usuarios', {
      'nombre': 'Profesora Ana',
      'correo': 'ana@escuela.com',
      'contrasena': 'ana123',
      'rol': 'profesor',
    });

    // ======== TABLA DE ESTUDIANTES ========
    await db.execute('''
      CREATE TABLE estudiantes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT NOT NULL,
        grado TEXT NOT NULL
      )
    ''');

    // ======== TABLA DE NOTAS ========
    await db.execute('''
      CREATE TABLE notas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        estudiante_id INTEGER,
        asignatura TEXT NOT NULL,
        nota REAL NOT NULL,
        fecha TEXT,
        FOREIGN KEY (estudiante_id) REFERENCES estudiantes (id)
      )
    ''');
  }

  // ================= MÉTODOS USUARIOS =================
  Future<int> insertarUsuario(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('usuarios', data);
  }

  Future<Map<String, dynamic>?> login(String correo, String contrasena) async {
    final db = await database;
    final result = await db.query(
      'usuarios',
      where: 'correo = ? AND contrasena = ?',
      whereArgs: [correo, contrasena],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // ================= MÉTODOS ESTUDIANTES =================
  Future<int> insertEstudiante(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('estudiantes', data);
  }

  Future<List<Map<String, dynamic>>> getEstudiantes() async {
    final db = await database;
    return await db.query('estudiantes');
  }

  // ================= MÉTODOS NOTAS =================
  Future<int> insertNota(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('notas', data);
  }

  Future<List<Map<String, dynamic>>> getNotas() async {
    final db = await database;
    return await db.query('notas');
  }
}
