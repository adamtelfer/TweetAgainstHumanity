/**
 *  \file       Category.h
 *  \author     XMG Studio
 *  \date       10-10-08
 *  \ingroup    XMGLib
 **/

/**
 *  \def        FIX_CATEGORY_BUG(name)
 *  \brief      Fix for Categories included in static libraries. 
 *  \details    In your file which has only an implementation of category methods,
 *              define FIX_CATEGORY_BUG(<name of file>). This forces the linker to include
 *              any definitions of category methods. Please see http://blog.binaryfinery.com/universal-static-library-problem-in-iphone-sd
 *              for more detail.
 */
#define FIX_CATEGORY_BUG(name) @interface FIXCATEGORYBUG ## name @end @implementation FIXCATEGORYBUG ## name @end