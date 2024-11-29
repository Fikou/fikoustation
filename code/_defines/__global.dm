#define GLOBAL_VAR(name, value) /datum/global_vars/var/global/##name = ##value

#define GLOBAL_LIST_EMPTY(name) GLOBAL_VAR(name, list())
#define GLOBAL_LIST_INIT(name, newlist) GLOBAL_VAR(name, newlist)
