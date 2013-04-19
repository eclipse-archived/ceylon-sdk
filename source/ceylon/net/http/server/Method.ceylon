
doc "Http request method"
by "Jean-Charles Roger"
shared abstract class Method() of options | get | head | post | put | delete | trace | connect {}

shared object options extends Method() {}
shared object get extends Method() {}
shared object head extends Method() {}
shared object post extends Method() {}
shared object put extends Method() {}
shared object delete extends Method() {}
shared object trace extends Method() {}
shared object connect extends Method() {}
