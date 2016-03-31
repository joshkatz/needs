install <- quote(
  if (!requireNamespace("needs")) {
    install.packages("needs")
    needs:::autoload(T)
  }
)
