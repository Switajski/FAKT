//////////////////////////////////////////////////////////////////////
//
//  Copyright:
//        Your Copyright goes here., (c) 2000. All rights reserved.
//
//  Contents:
//        This is a generic package DLL which provides you the nec.
//        interfaces to register your Plugin into Visual Xbase++
//////////////////////////////////////////////////////////////////////

#include "Common.ch"

/* The register callback is executed at the time the Package DLL
 * gets loaded. You should use this callback to register
 * entry points for your Wizard, DOT and Component features.
 * You can use this load hook also to perform some basic
 * initialization. Return .T. to signal success or .F. to force
 * abort of package loading
 */
FUNCTION _Register(oVX)
  LOCAL lSuccess := .T.  // default to successfull init
  // $TODO$ register your features
  // oVX:registerCommandHandler("myFunction",VXDOT_EXECUTION_LEVEL,"Single Character Command Prefix")
  // oVX:registerWizard("ClassName",VXWIZARD_TYPE)
  // oVX:registerComponent("VXComponentName","AssemblyName==DLL",VXPALETTE_STANDARD | "Your Own Tab")
  //
  // $TODO
  // Perform your initialization actions here like execution of
  // a specific script
  // oVX:RunScript("test.vxs")
  //
RETURN lSuccess

/* Deregister callback can be used to perform any housekeeping
 * task. Registered features are automatically deregistered.
 */
FUNCTION _Deregister(oVX)
  LOCAL lOk := .T. // default to enable package unload
RETURN lOk

/* this callback is used by to expose version details
 */
FUNCTION _Version()
  // $TODO$ place your version text here!
RETURN "Version 1.0"

/* this callback is used to expose your copyright
 */
FUNCTION _Copyright()
  // $TODO$ place your copyright here!
RETURN "Copyright (C) 2000, ..."

// EOF