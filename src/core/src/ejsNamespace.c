/**
    ejsNamespace.c - Ejscript Namespace class

    Copyright (c) All Rights Reserved. See details at the end of the file.
 */

/********************************** Includes **********************************/

#include    "ejs.h"

/************************************* Code ***********************************/
/*
    Cast the operand to the specified type
 */

static EjsAny *castNamespace(Ejs *ejs, EjsNamespace *vp, EjsType *type)
{
    switch (type->sid) {
    case S_Boolean:
        return ejsCreateBoolean(ejs, 1);

    case S_String:
        return vp->value;

    default:
        ejsThrowTypeError(ejs, "Cannot cast to this type");
        return 0;
    }
}


static EjsAny *invokeNamespaceOperator(Ejs *ejs, EjsNamespace *lhs, int opCode, EjsNamespace *rhs)
{
    bool        boolResult;

    switch (opCode) {
    case EJS_OP_COMPARE_EQ:
        if (!ejsIsDefined(ejs, rhs)) {
            return ((opCode == EJS_OP_COMPARE_EQ) ? ESV(false): ESV(true));
        }
        boolResult = ejsCompareString(ejs, lhs->value, rhs->value) == 0;
        break;

    case EJS_OP_COMPARE_STRICTLY_EQ:
        boolResult = lhs == rhs;
        break;

    case EJS_OP_COMPARE_NE:
        if (!ejsIsDefined(ejs, rhs)) {
            return ((opCode == EJS_OP_COMPARE_EQ) ? ESV(false): ESV(true));
        }
        boolResult = !(ejsCompareString(ejs, lhs->value, rhs->value) == 0);
        break;

    case EJS_OP_COMPARE_STRICTLY_NE:
        boolResult = !(lhs == rhs);
        break;

    default:
        ejsThrowTypeError(ejs, "Operation is not valid on this type");
        return 0;
    }
    return ejsCreateBoolean(ejs, boolResult);
}


/*
    Define a reserved namespace in a block.
 */
PUBLIC EjsNamespace *ejsDefineReservedNamespace(Ejs *ejs, EjsBlock *block, EjsName *typeName, cchar *spaceName)
{
    EjsNamespace    *namespace;

    namespace = ejsCreateReservedNamespace(ejs, typeName, ejsCreateStringFromAsc(ejs, spaceName));
    if (namespace && block && ejsAddNamespaceToBlock(ejs, block, namespace) < 0) {
        return 0;
    }
    return namespace;
}


/*
    Format a reserved namespace to create a unique namespace. "internal, public, private, protected"

    Namespaces are formatted as strings using the following format, where type is optional. Types may be qualified.
        [type,space]

    Example:
        [debug::Shape,public] where Shape was declared as "debug class Shape"
 */
PUBLIC EjsString *ejsFormatReservedNamespace(Ejs *ejs, EjsName *typeName, EjsString *spaceName)
{
    EjsString   *namespace;

    if (typeName) {
        if (typeName->space && typeName->space == ESV(public)) {
            namespace = ejsSprintf(ejs, "[%N,%@]", *typeName, spaceName);
        } else {
            namespace = ejsSprintf(ejs, "[%@,%@]", typeName->name, spaceName);
        }
    } else {
        namespace = ejsSprintf(ejs, "[%@]", spaceName);
    }
    return namespace;
}


/*********************************** Factory **********************************/
/*
    Create a namespace with the given name as its definition value.
 */
PUBLIC EjsNamespace *ejsCreateNamespace(Ejs *ejs, EjsString *name)
{
    EjsNamespace    *np;

    if ((np = ejsCreateObj(ejs, ESV(Namespace), 0)) == 0) {
        return 0;
    }
    np->value = name;
    mprSetName(np, "namespace");
    return np;
}


/*
    Create a reserved namespace. Format the package, type and space names to create a unique namespace.
 */
PUBLIC EjsNamespace *ejsCreateReservedNamespace(Ejs *ejs, EjsName *typeName, EjsString *spaceName)
{
    EjsString       *formattedName;

    assert(spaceName);

    if (typeName) {
        formattedName = ejsFormatReservedNamespace(ejs, typeName, spaceName);
    } else {
        formattedName = spaceName;
    }
    return ejsCreateNamespace(ejs, formattedName);
}


static void manageNamespace(EjsNamespace *ns, int flags)
{
    if (flags & MPR_MANAGE_MARK) {
        mprMark(ns->value);
    }
}


PUBLIC void ejsCreateNamespaceType(Ejs *ejs)
{
    EjsType     *type;

    type = ejsCreateCoreType(ejs, N("ejs", "Namespace"), sizeof(EjsNamespace), S_Namespace, ES_Namespace_NUM_CLASS_PROP,
        manageNamespace, EJS_TYPE_OBJ | EJS_TYPE_IMMUTABLE_INSTANCES);
    type->helpers.cast = (EjsCastHelper) castNamespace;
    type->helpers.invokeOperator = (EjsInvokeOperatorHelper) invokeNamespaceOperator;
}


PUBLIC void ejsConfigureNamespaceType(Ejs *ejs)
{
    EjsType     *type;

    if ((type = ejsFinalizeCoreType(ejs, N("ejs", "Namespace"))) == 0) {
        return;
    }
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
