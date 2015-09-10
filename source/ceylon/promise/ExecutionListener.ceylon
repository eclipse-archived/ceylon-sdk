shared interface ExecutionListener {

  "This method is invoked when a child is created so it can capture the context of the creation of the promise's child.
   The returned function can then apply this context on its children."
  shared formal Anything(Anything()) onChild();
}