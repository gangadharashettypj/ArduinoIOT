/*
 * @Author GS
 */

enum ConnectionType { HTTP, UDP }

class LocalData {
  static ConnectionType connectionType = ConnectionType.HTTP;
  static String username = 'user';
  static String password = 'pass';
}
