
//@beginlicenses@
//@license{Stefan Seefeld}{2004}@
//
//  Permission to use, copy, distribute and modify this software and its  
//  documentation for any purpose is hereby granted without fee, provided that
//  the above copyright notice appears in all copies and that both that copyright
//  notice and this permission notice appear in supporting documentation.
// 
//  Stefan Seefeld make(s) no representations about the suitability of this
//  software for any purpose. It is provided "as is" without express or implied
//  warranty.
//  
//  Copyright (C) 2004 Stefan Seefeld
//
//@endlicenses@

/*
  Copyright (C) 2004 Stefan Seefeld

  Permission to use, copy, distribute and modify this software and
  its documentation for any purpose is hereby granted without fee,
  provided that the above copyright notice appear in all copies and that
  both that copyright notice and this permission notice appear in
  supporting documentation.
*/
#ifndef guard_opencxx_parser_GC_h
#define guard_opencxx_parser_GC_h

// define dummy replacements for GC allocator operators

#ifdef USE_BOEHM_GC

#include <gc/gc_cpp.h>

namespace Opencxx
{

typedef gc LightObject;
typedef gc_cleanup Object;

inline
int GcCount()
{
    return GC_gc_no;
}

}

#else

#include <new>

namespace Opencxx
{

enum GCPlacement {GC, NoGC};
class LightObject {};
class Object {};

inline
int GcCount()
{
    return 0;
}

}

inline void* operator new(std::size_t size, Opencxx::GCPlacement gcp)
{
    return ::operator new(size);
}

inline void* operator new [](std::size_t size, Opencxx::GCPlacement gcp)
{
    return ::operator new [](size);
}

#endif

#endif
