/*
 * MATLAB Compiler: 4.6 (R2007a)
 * Date: Tue Mar 15 17:10:07 2011
 * Arguments: "-B" "macro_default" "-o" "tapedrive2" "-W" "main" "-d"
 * "C:\Documents and Settings\Admin\My
 * Documents\software_tapedrive\develop\tapedrive2\src" "-T" "link:exe" "-v"
 * "C:\Documents and Settings\Admin\My
 * Documents\software_tapedrive\develop\tapedrive.m" 
 */

#include "mclmcr.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_tapedrive2_session_key[] = {
        '3', '2', '0', '0', '2', '8', '7', '2', 'E', '2', 'F', '1', '8', '2',
        '4', '0', '2', '6', 'D', 'B', 'D', '9', 'D', '6', '8', '4', 'A', 'A',
        'F', 'C', '2', '5', '6', '5', 'D', 'C', 'B', '0', '4', '3', '4', '5',
        '2', '4', '1', '3', 'F', '1', 'D', '8', '4', 'D', '2', 'F', 'B', '4',
        'B', 'B', '5', '1', 'E', 'F', '8', 'E', '2', 'A', '1', 'E', '4', '5',
        '4', '9', '8', 'B', 'B', '2', 'A', 'E', 'C', '4', '2', 'E', 'E', '3',
        '0', '5', 'B', '8', '4', 'E', '2', '6', 'C', 'C', 'F', '9', '3', '3',
        'E', '7', 'B', '6', 'B', '6', '5', '7', '7', '5', 'A', '9', '0', 'D',
        '6', 'E', '1', '3', 'D', '8', '1', 'A', 'B', '3', 'F', '4', '5', '2',
        '1', '2', '7', 'B', '2', '0', '7', '2', '8', '1', '7', 'D', '7', 'F',
        'D', '1', 'B', 'B', '6', 'F', '6', 'F', '7', 'B', '8', '4', 'D', '0',
        '2', '8', '7', 'A', '3', '3', '2', 'E', '3', '7', 'D', 'B', '1', '9',
        'B', '6', 'E', 'B', '8', 'E', '1', 'B', 'F', 'A', '9', '2', '4', 'E',
        'E', 'D', '8', '8', 'A', '9', 'F', '0', '3', '9', 'A', '0', '9', '8',
        'B', '4', '1', '4', '2', '6', '2', '8', '9', '8', '0', 'C', '8', '1',
        '9', '2', '4', '5', '8', '3', 'D', '8', '2', 'C', '9', '4', '5', '5',
        'A', '5', '2', '2', 'C', '6', '9', '9', 'C', 'F', 'C', '4', 'F', 'B',
        '8', 'B', '7', 'C', 'C', '1', '1', 'D', 'E', '0', 'E', '5', '2', 'A',
        '5', 'B', '9', 'F', '\0'};

const unsigned char __MCC_tapedrive2_public_key[] = {
        '3', '0', '8', '1', '9', 'D', '3', '0', '0', 'D', '0', '6', '0', '9',
        '2', 'A', '8', '6', '4', '8', '8', '6', 'F', '7', '0', 'D', '0', '1',
        '0', '1', '0', '1', '0', '5', '0', '0', '0', '3', '8', '1', '8', 'B',
        '0', '0', '3', '0', '8', '1', '8', '7', '0', '2', '8', '1', '8', '1',
        '0', '0', 'C', '4', '9', 'C', 'A', 'C', '3', '4', 'E', 'D', '1', '3',
        'A', '5', '2', '0', '6', '5', '8', 'F', '6', 'F', '8', 'E', '0', '1',
        '3', '8', 'C', '4', '3', '1', '5', 'B', '4', '3', '1', '5', '2', '7',
        '7', 'E', 'D', '3', 'F', '7', 'D', 'A', 'E', '5', '3', '0', '9', '9',
        'D', 'B', '0', '8', 'E', 'E', '5', '8', '9', 'F', '8', '0', '4', 'D',
        '4', 'B', '9', '8', '1', '3', '2', '6', 'A', '5', '2', 'C', 'C', 'E',
        '4', '3', '8', '2', 'E', '9', 'F', '2', 'B', '4', 'D', '0', '8', '5',
        'E', 'B', '9', '5', '0', 'C', '7', 'A', 'B', '1', '2', 'E', 'D', 'E',
        '2', 'D', '4', '1', '2', '9', '7', '8', '2', '0', 'E', '6', '3', '7',
        '7', 'A', '5', 'F', 'E', 'B', '5', '6', '8', '9', 'D', '4', 'E', '6',
        '0', '3', '2', 'F', '6', '0', 'C', '4', '3', '0', '7', '4', 'A', '0',
        '4', 'C', '2', '6', 'A', 'B', '7', '2', 'F', '5', '4', 'B', '5', '1',
        'B', 'B', '4', '6', '0', '5', '7', '8', '7', '8', '5', 'B', '1', '9',
        '9', '0', '1', '4', '3', '1', '4', 'A', '6', '5', 'F', '0', '9', '0',
        'B', '6', '1', 'F', 'C', '2', '0', '1', '6', '9', '4', '5', '3', 'B',
        '5', '8', 'F', 'C', '8', 'B', 'A', '4', '3', 'E', '6', '7', '7', '6',
        'E', 'B', '7', 'E', 'C', 'D', '3', '1', '7', '8', 'B', '5', '6', 'A',
        'B', '0', 'F', 'A', '0', '6', 'D', 'D', '6', '4', '9', '6', '7', 'C',
        'B', '1', '4', '9', 'E', '5', '0', '2', '0', '1', '1', '1', '\0'};

static const char * MCC_tapedrive2_matlabpath_data[] = 
    { "tapedrive2/", "toolbox/compiler/deploy/", "$TOOLBOXMATLABDIR/general/",
      "$TOOLBOXMATLABDIR/ops/", "$TOOLBOXMATLABDIR/lang/",
      "$TOOLBOXMATLABDIR/elmat/", "$TOOLBOXMATLABDIR/elfun/",
      "$TOOLBOXMATLABDIR/specfun/", "$TOOLBOXMATLABDIR/matfun/",
      "$TOOLBOXMATLABDIR/datafun/", "$TOOLBOXMATLABDIR/polyfun/",
      "$TOOLBOXMATLABDIR/funfun/", "$TOOLBOXMATLABDIR/sparfun/",
      "$TOOLBOXMATLABDIR/scribe/", "$TOOLBOXMATLABDIR/graph2d/",
      "$TOOLBOXMATLABDIR/graph3d/", "$TOOLBOXMATLABDIR/specgraph/",
      "$TOOLBOXMATLABDIR/graphics/", "$TOOLBOXMATLABDIR/uitools/",
      "$TOOLBOXMATLABDIR/strfun/", "$TOOLBOXMATLABDIR/imagesci/",
      "$TOOLBOXMATLABDIR/iofun/", "$TOOLBOXMATLABDIR/audiovideo/",
      "$TOOLBOXMATLABDIR/timefun/", "$TOOLBOXMATLABDIR/datatypes/",
      "$TOOLBOXMATLABDIR/verctrl/", "$TOOLBOXMATLABDIR/codetools/",
      "$TOOLBOXMATLABDIR/helptools/", "$TOOLBOXMATLABDIR/winfun/",
      "$TOOLBOXMATLABDIR/demos/", "$TOOLBOXMATLABDIR/timeseries/",
      "$TOOLBOXMATLABDIR/hds/", "$TOOLBOXMATLABDIR/guide/",
      "$TOOLBOXMATLABDIR/plottools/", "toolbox/local/", "toolbox/compiler/" };

static const char * MCC_tapedrive2_classpath_data[] = 
    { "" };

static const char * MCC_tapedrive2_libpath_data[] = 
    { "" };

static const char * MCC_tapedrive2_app_opts_data[] = 
    { "" };

static const char * MCC_tapedrive2_run_opts_data[] = 
    { "" };

static const char * MCC_tapedrive2_warning_state_data[] = 
    { "off:MATLAB:dispatcher:nameConflict" };


mclComponentData __MCC_tapedrive2_component_data = { 

    /* Public key data */
    __MCC_tapedrive2_public_key,

    /* Component name */
    "tapedrive2",

    /* Component Root */
    "",

    /* Application key data */
    __MCC_tapedrive2_session_key,

    /* Component's MATLAB Path */
    MCC_tapedrive2_matlabpath_data,

    /* Number of directories in the MATLAB Path */
    36,

    /* Component's Java class path */
    MCC_tapedrive2_classpath_data,
    /* Number of directories in the Java class path */
    0,

    /* Component's load library path (for extra shared libraries) */
    MCC_tapedrive2_libpath_data,
    /* Number of directories in the load library path */
    0,

    /* MCR instance-specific runtime options */
    MCC_tapedrive2_app_opts_data,
    /* Number of MCR instance-specific runtime options */
    0,

    /* MCR global runtime options */
    MCC_tapedrive2_run_opts_data,
    /* Number of MCR global runtime options */
    0,
    
    /* Component preferences directory */
    "tapedrive2_0937230D7861E310D805F7D2B2064E7F",

    /* MCR warning status data */
    MCC_tapedrive2_warning_state_data,
    /* Number of MCR warning status modifiers */
    1,

    /* Path to component - evaluated at runtime */
    NULL

};

#ifdef __cplusplus
}
#endif


