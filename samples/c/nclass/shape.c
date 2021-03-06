/*
    shape.c - Native class implementation for the Shape class. 

    This smple provides the implementation for the Shape class. It defines the native class itsself and defines storage
    for its properties and methods. It thus uses a native C structure for Shape instance state and native C language types
    for properties. 

    The Shape properties are NOT stored as discreate JavaScript properties. Rather they are stored as native C data
    types in the instance state structure. This provides the most compact memory organization and is much smaller
    than using Script classes or standard native classes. The trade-off, however, is more code, so if you are only 
    going to create a small number of object instances, then scripted classes or normal native classes are a probably
    a better choice. But if you will be creating lots of instances or if your class has a very large number of 
    properties, then composite classes are ideal.

    Copyright (c) All Rights Reserved. See details at the end of the file.
 */

/********************************** Includes **********************************/

#include    "ejs.h"

/*
    Indent so that genDepend won't warn first time when this file doesn't exist
 */
 #include   "nclass.slots.h"

/*********************************** Locals ***********************************/
/*
    Native class for the Shape instance state.
 */

typedef struct Shape {
    EjsObj      var;                /* Logically extends Object */
    int         x;                  /* x property */
    int         y;                  /* y property */
    int         height;             /* height property */
    int         width;              /* width property */
} Shape;

/*********************************** Helpers **********************************/
/*
    Create a new Shape instance. Use by the VM to create instances.

    @param ejs VM handle.
    @param type Shape type class object from which to create an instance.
    @param size Number of extra slots to allocate (ignored).
 */
Shape *create(Ejs *ejs, EjsType *type, int size)
{
    return ejsAlloc(ejs, type, 0);
}

/*
    Copy all properties of the instance including all references. If deep is true and if some properties are 
    reference types, then recursively copy all their properties and so on.

    @param ejs VM handle.
    @param sp is set to the object instance to clone. 
    @return The newly copied object
 */
static EjsObj *cloneShape(Ejs *ejs, Shape *sp, bool deep)
{
    Shape   *newShape;

    newShape = ejsCreateObj(ejs, TYPE(sp), 0);
    if (newShape == 0) {
        ejsThrowMemoryError(ejs);
        return 0;
    }

    newShape->x = sp->x;
    newShape->y = sp->y;
    newShape->height = sp->height;
    newShape->width = sp->width;

    return (EjsObj*) newShape;
}

/*
    Get a property from the object

    @param ejs VM handle.
    @param sp is set to the object instance.
    @param slotNum Slot number of the property to retrieve. The VM maps the property names to slots.
    @return the property value
 */
static EjsObj *getProperty(Ejs *ejs, Shape *sp, int slotNum)
{
    mprAssert(sp);

    switch (slotNum) {
    case ES_nclass_Shape_x:
        return (EjsObj*) ejsCreateNumber(ejs, sp->x);

    case ES_nclass_Shape_y:
        return (EjsObj*) ejsCreateNumber(ejs, sp->x);

    case ES_nclass_Shape_height:
        return (EjsObj*) ejsCreateNumber(ejs, sp->height);

    case ES_nclass_Shape_width:
        return (EjsObj*) ejsCreateNumber(ejs, sp->width);

    default:
        ejsThrowReferenceError(ejs, "Bad slot reference");
    }
    return 0;
}

/*
    Return the number of instance properties.

    @param ejs VM handle.
    @param sp is set to the object instance.
    @return The number of properties
 */
static int getPropertyCount(Ejs *ejs, Shape *sp)
{
    /*
        The slot file computes this for us
     */
    return ES_nclass_Shape_NUM_INSTANCE_PROP;
}

/*
    Get a property name

    @param ejs VM handle.
    @param sp is set to the object instance. 
    @param slotNum Slot number of the property to retrieve. The VM maps the property names to slots.
    @return The qualified property name.
 */
static EjsName getPropertyName(Ejs *ejs, Shape *sp, int slotNum)
{
    /*
        To be thread-safe, we must have a different qname structure for each property name.
     */
    switch (slotNum) {
        case ES_nclass_Shape_x: {
            static EjsName qname;
            qname.name = ejsCreateStringFromAsc(ejs, "y");
            qname.space = 0;
            return qname;
        }

        case ES_nclass_Shape_y: {
            static EjsName qname;
            qname.space = 0;
            return qname;
        }

        case ES_nclass_Shape_height: {
            static EjsName qname;
            qname.name = ejsCreateStringFromAsc(ejs, "height");
            qname.space = 0;
            return qname;
         }

        case ES_nclass_Shape_width: {
            static EjsName qname;
            qname.name = ejsCreateStringFromAsc(ejs, "width");
            qname.space = 0;
            return qname;
        }

        default: {
            static EjsName qname;
            qname.name = 0;
            qname.space = 0;
            ejsThrowReferenceError(ejs, "Bad slot reference");
            return qname;
        }
    }
}

/*
    Lookup a property by name. This is optionally implemented by native types and could be further optimized by 
    hashing these properties. Note: the compiler binds most references to typed properties, so this routine
    should not be called often.

    @param ejs VM handle.
    @param sp is set to the object instance. 
    @param name Property name to look for.
 */
static int lookupProperty(Ejs *ejs, Shape *sp, EjsName *qname)
{
    MprChar     *name;

    name = qname->name->value;
    if (mcmp(name, "x") == 0) {
        return ES_nclass_Shape_x;

    } else if (mcmp(name, "y") == 0) {
        return ES_nclass_Shape_y;

    } else if (mcmp(name, "height") == 0) {
        return ES_nclass_Shape_height;

    } else if (mcmp(name, "width") == 0) {
        return ES_nclass_Shape_width;

    } else {
        ejsThrowReferenceError(ejs, "Cannot find property %@", qname->name);
        return EJS_ERR;
    }
}

/*
    Update the value of the property at slotNum with the given value

    @param ejs VM handle.
    @param lhs Left hand side object.
    @param slotNum Slot number of the property to update. The VM maps the property names to slots.
    @param value Value to write to the property.
 */ 
static int setProperty(Ejs *ejs, Shape *sp, int slotNum, EjsObj *value)
{
    mprAssert(sp);

    switch (slotNum) {
    case ES_nclass_Shape_x:
        sp->x = ejsGetInt(ejs, value);
        break;

    case ES_nclass_Shape_y:
        sp->y = ejsGetInt(ejs, value);
        break;

    case ES_nclass_Shape_height:
        sp->height = ejsGetInt(ejs, value);
        break;

    case ES_nclass_Shape_width:
        sp->width = ejsGetInt(ejs, value);
        break;

    default:
        ejsThrowReferenceError(ejs, "Bad slot reference");
        return EJS_ERR;
    }
    return slotNum;
}

#if UNUSED
/*
    These methods are not required for this sample, but are included to demonstrate their use.
 */

/*
    Cast the instance to another type. 

    @param ejs VM handle.
    @param sp is set to the object instance.
    @returns the function result or 0 if an exception is thrown.
 */
static EjsObj *castVar(Ejs *ejs, Shape *sp, EjsType *type)
{
    return (EjsObj*) ejsCreateString(ejs, "[object Shape]");
}

/*
    Delete the property at the specified slot.

    @param ejs VM handle.
    @param sp is set to the object instance.
    @returns 0 if the delete is successful. Otherwise a negative error code.
 */
static int deleteProperty(Ejs *ejs, Shape *sp, const char *prop)
{
    ejsThrowTypeError(ejs, "Cannot delete properties for this type");
    return EJS_ERR;
}

/*
    Delete an instance property by name.
 */
static int deletePropertyByName(Ejs *ejs, EjsObject *obj, EjsName *qname)
{
    ejsThrowTypeError(ejs, "Cannot delete properties for this type");
    return EJS_ERR;
}

/*
    Free allocated memory before returning the object to the pool. 

    @param ejs VM handle.
    @param sp is set to the object instance.
 */
static int finalizeVar(Ejs *ejs, Shape *sp)
{
    /*  Free any object state here before an object is garbage collected */
    return 0;
}

/*
    Destroy the instance. The default implementation is to just call the GC ejsFreeVar routine which will 
    either free the memory or return it to a type specific pool, ready for reuse
 */
static void destroyVar(Ejs *ejs, EjsObj *obj)
{
    ejsFreeVar(ejs, obj);
}

int defineProperty(Ejs *ejs, EjsObj *vp, int slotNum, EjsName *name, EjsType *propType, int attributes, EjsObj *value)
{
    ejsThrowReferenceError(ejs, "Cannot define properties in this sample");
    return EJS_ERR;
}

/*
    Implement byte code operators.

    @param ejs VM handle.
    @param lhs Left hand side object.
    @param opCode Bytecode opcode to invoke.
    @param rhs Right hand side object.
 */
static EjsObj *invokeOperator(Ejs *ejs, Shape *lhs, int opCode, Shape *rhs)
{
    switch (opCode) {

    case EJS_OP_COMPARE_EQ: case EJS_OP_COMPARE_STRICTLY_EQ:
    case EJS_OP_COMPARE_LE: case EJS_OP_COMPARE_GE:
        return (EjsObj*) ejsCreateBoolean(ejs, lhs == rhs);

    case EJS_OP_COMPARE_NE: case EJS_OP_COMPARE_STRICTLY_NE:
    case EJS_OP_COMPARE_LT: case EJS_OP_COMPARE_GT:
        return (EjsObj*) ejsCreateBoolean(ejs, !(lhs == rhs));

    default:
        /*
            Pass to the standard Object helpers to implement other op codes
         */
        return (ejs->defaultHelpers->invokeOperator)(ejs, (EjsObj*) lhs, opCode, (EjsObj*) rhs);
    }
    return 0;
}

/*
    Mark the non-native properties for the garbage collector
 */
static void markVar(Ejs *ejs, EjsObj *parent, EjsObj *sp)
{
    /*
        Call ejsMarkVar on all contained Ejscript properties or objects.
     */
}

/*
    Update a property's name (hash name)

    @param ejs VM handle.
    @param sp is set to the object instance. 
    @param sloNum Property slot number to set.
    @param name Property name to set.
 */
static EjsObj *setPropertyName(Ejs *ejs, Shape *sp, int slotNum, EjsName *name)
{
    ejsThrowReferenceError(ejs, "Cannot define property names for this type");
    return 0;
}
#endif

/******************************************************************************/
/*
    The constructor's job is to initialize a bare object instance

    function Constructor(height: num, width: num
 */
static EjsObj *constructor(Ejs *ejs, Shape *sp, int argc, EjsObj **argv)
{
    mprAssert(sp);
    mprAssert(argc == 2);

    mprLog(1, "Shape()\n");

    sp->x = 0;
    sp->y = 0;
    sp->height = ejsGetInt(ejs, argv[0]);
    sp->width = ejsGetInt(ejs, argv[0]);

    return (EjsObj*) sp;
}

/*
    Compute the area of the shape

    function area(): Number
 */
static EjsNumber *area(Ejs *ejs, Shape *sp, int argc, EjsObj **argv)
{
    return ejsCreateNumber(ejs, sp->height *sp->width);
}

/******************************************************************************/
/*
    Create the Shape class
 */

EjsType *ejsDefineShapeType(Ejs *ejs)
{
    EjsHelpers      *helpers;
    EjsType         *type;
    EjsPot          *prototype;

    /*
        Get the Shape class object. This will be created from the mod file for us. But we need to set the object
        instance size.
     */
    if ((type = ejsGetPropertyByName(ejs, ejs->global, N(EJS_PUBLIC_NAMESPACE, "Shape"))) == 0) {
        mprError("Cannot find class Shape");
        return 0;
    }
    type->instanceSize = sizeof(Shape);
    prototype = type->prototype;

    /*
        Define the helper functions.
     */
    helpers = &type->helpers;
    helpers->clone                  = (EjsCloneHelper) cloneShape;
    helpers->create                 = (EjsCreateHelper) create;
    helpers->getProperty            = (EjsGetPropertyHelper) getProperty;
    helpers->getPropertyCount       = (EjsGetPropertyCountHelper) getPropertyCount;
    helpers->getPropertyName        = (EjsGetPropertyNameHelper) getPropertyName;
    helpers->lookupProperty         = (EjsLookupPropertyHelper) lookupProperty;
    helpers->setProperty            = (EjsSetPropertyHelper) setProperty;

#if UNUSED
    /*
        Other possible helpers. For this sample, the default helpers are sufficient. Override these if required 
        in your native class.
     */
    helpers->castVar                = (EjsCastHelper) castVar;
    helpers->defineProperty         = (EjsDefinePropertyHelper) defineProperty;
    helpers->destroyVar             = (EjsDestroyHelper) destroyVar;
    helpers->deleteProperty         = (EjsDeletePropertyHelper) deleteProperty;
    helpers->deletePropertyByName   = (EjsDeletePropertyByNameHelper) deletePropertyByName;
    helpers->finalizeVar            = (EjsFinalizeHelper) finalizeVar;
    helpers->invokeOperator         = (EjsInvokeOperatorHelper) invokeOperator;
    helpers->markVar                = (EjsMarkHelper) markVar;
    helpers->setPropertyName        = (EjsSetPropertyNameHelper) setPropertyName;
#endif

    /*
        Bind the C functions to the JavaScript functions. We use the slot definitions generated
        by ejsmod from Shape.es.
     */
    ejsBindConstructor(ejs, type, constructor);
    ejsBindMethod(ejs, prototype, ES_nclass_Shape_area, area);
    return type;
}

/******************************************************************************/
/*
    Shape loadable module entry point. This will be called by the Ejscript loader 
    after the Shape.mod file is loaded and before Shape initializers are run. 

    Module entry points be named [NAME]ModuleInit where "[NAME]" is the name of 
    the module starting with a lower case letter and  with any "." characters 
    converted to underscores.
 */
int configureSampleTypes(Ejs *ejs)
{
    EjsType     *type;

    mprLog(1, "Loading Sample module");

    /*
        Get the Shape class object. This will be created from the mod file for us.
     */
    type = ejsGetTypeByName(ejs, N("nclass", "Shape"));
    if (type == 0) {
        mprError("Cannot find type Shape");
        return MPR_ERR_CANT_ACCESS;
    }

    /*
        Bind the C functions to the JavaScript functions. We use the slot definitions generated
        by ejsmod from Shape.es.
     */
    ejsBindConstructor(ejs, type, constructor);
    ejsBindMethod(ejs, type, ES_nclass_Shape_area, area);
    return 0;
}


int nclass_Init(Ejs *ejs, MprModule *module)
{
    return ejsAddNativeModule(ejs, "nclass", configureSampleTypes, _ES_CHECKSUM_nclass, EJS_LOADER_ETERNAL);
}

/*
    @copy   default

    Copyright (c) Embedthis Software. All Rights Reserved.

    This software is distributed under commercial and open source licenses.
    You may use the Embedthis Open Source license or you may acquire a 
    commercial license from Embedthis Software. You agree to be fully bound
    by the terms of either license. Consult the LICENSE.md distributed with
    this software for full details and other copyrights.

    Local variables:
    tab-width: 4
    c-basic-offset: 4
    End:
    vim: sw=4 ts=4 expandtab

    @end
 */
