

extension StringToInt on String {
  int toInt() => int.parse(this);
}

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}