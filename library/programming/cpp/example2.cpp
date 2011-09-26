template <class Type >
Type min ( Type a, Type b) {
  return a < b ? a : b;
}

main() {
  // ok: int min(int,int);
  min(10, 20);

  // ok: double min(double,double);
  min(10.0, 20.0);
  return 0;
}
