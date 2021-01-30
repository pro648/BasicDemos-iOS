// 省略...

#pragma clang assume_nonnull end

#pragma clang assume_nonnull begin


#ifndef _REWRITER_typedef_Child
#define _REWRITER_typedef_Child
typedef struct objc_object Child;
typedef struct {} _objc_exc_Child;
#endif

struct Child_IMPL {
	struct NSObject_IMPL NSObject_IVARS;
};


// - (void)run;

/* @end */

#pragma clang assume_nonnull end

#pragma clang assume_nonnull begin

// @interface Child (Test1)

// @property (nonatomic, strong) NSString *title;
// - (void)test;

/* @end */

#pragma clang assume_nonnull end

// @implementation Child (Test1)


static void _I_Child_Test1_test(Child * self, SEL _cmd) {
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_05_pj1lwvjs50j3gx6vjtvxcvf80000gn_T_Child_Test1_8b1a83_mi_0, 13, __PRETTY_FUNCTION__);
}


static void _I_Child_Test1_run(Child * self, SEL _cmd) {
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_05_pj1lwvjs50j3gx6vjtvxcvf80000gn_T_Child_Test1_8b1a83_mi_1, 17, __PRETTY_FUNCTION__);
}

// @end

struct _prop_t {
	const char *name;
	const char *attributes;
};

struct _protocol_t;

struct _objc_method {
	struct objc_selector * _cmd;
	const char *method_type;
	void  *_imp;
};

struct _protocol_t {
	void * isa;  // NULL
	const char *protocol_name;
	const struct _protocol_list_t * protocol_list; // super protocols
	const struct method_list_t *instance_methods;
	const struct method_list_t *class_methods;
	const struct method_list_t *optionalInstanceMethods;
	const struct method_list_t *optionalClassMethods;
	const struct _prop_list_t * properties;
	const unsigned int size;  // sizeof(struct _protocol_t)
	const unsigned int flags;  // = 0
	const char ** extendedMethodTypes;
};

struct _ivar_t {
	unsigned long int *offset;  // pointer to ivar offset location
	const char *name;
	const char *type;
	unsigned int alignment;
	unsigned int  size;
};

struct _class_ro_t {
	unsigned int flags;
	unsigned int instanceStart;
	unsigned int instanceSize;
	const unsigned char *ivarLayout;
	const char *name;
	const struct _method_list_t *baseMethods;
	const struct _objc_protocol_list *baseProtocols;
	const struct _ivar_list_t *ivars;
	const unsigned char *weakIvarLayout;
	const struct _prop_list_t *properties;
};

struct _class_t {
	struct _class_t *isa;
	struct _class_t *superclass;
	void *cache;
	void *vtable;
	struct _class_ro_t *ro;
};

struct _category_t {
	const char *name;
	struct _class_t *cls;
	const struct _method_list_t *instance_methods;
	const struct _method_list_t *class_methods;
	const struct _protocol_list_t *protocols;
	const struct _prop_list_t *properties;
};
extern "C" __declspec(dllimport) struct objc_cache _objc_empty_cache;
#pragma warning(disable:4273)

static struct /*_method_list_t*/ {
	unsigned int entsize;  // sizeof(struct _objc_method)
	unsigned int method_count;
	struct _objc_method method_list[2];
} _OBJC_$_CATEGORY_INSTANCE_METHODS_Child_$_Test1 __attribute__ ((used, section ("__DATA,__objc_const"))) = {
	sizeof(_objc_method),
	2,
	{{(struct objc_selector *)"test", "v16@0:8", (void *)_I_Child_Test1_test},
	{(struct objc_selector *)"run", "v16@0:8", (void *)_I_Child_Test1_run}}
};

static struct /*_prop_list_t*/ {
	unsigned int entsize;  // sizeof(struct _prop_t)
	unsigned int count_of_properties;
	struct _prop_t prop_list[1];
} _OBJC_$_PROP_LIST_Child_$_Test1 __attribute__ ((used, section ("__DATA,__objc_const"))) = {
	sizeof(_prop_t),
	1,
	{{"title","T@\"NSString\",&,N"}}
};

extern "C" __declspec(dllimport) struct _class_t OBJC_CLASS_$_Child;

static struct _category_t _OBJC_$_CATEGORY_Child_$_Test1 __attribute__ ((used, section ("__DATA,__objc_const"))) = 
{
	"Child",
	0, // &OBJC_CLASS_$_Child,
	(const struct _method_list_t *)&_OBJC_$_CATEGORY_INSTANCE_METHODS_Child_$_Test1,
	0,
	0,
	(const struct _prop_list_t *)&_OBJC_$_PROP_LIST_Child_$_Test1,
};
static void OBJC_CATEGORY_SETUP_$_Child_$_Test1(void ) {
	_OBJC_$_CATEGORY_Child_$_Test1.cls = &OBJC_CLASS_$_Child;
}
#pragma section(".objc_inithooks$B", long, read, write)
__declspec(allocate(".objc_inithooks$B")) static void *OBJC_CATEGORY_SETUP[] = {
	(void *)&OBJC_CATEGORY_SETUP_$_Child_$_Test1,
};
static struct _category_t *L_OBJC_LABEL_CATEGORY_$ [1] __attribute__((used, section ("__DATA, __objc_catlist,regular,no_dead_strip")))= {
	&_OBJC_$_CATEGORY_Child_$_Test1,
};
static struct IMAGE_INFO { unsigned version; unsigned flag; } _OBJC_IMAGE_INFO = { 0, 2 };
