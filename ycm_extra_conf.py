# global ycm_extra_conf.py
# copied from YouCompleteMe source code

from distutils.sysconfig import get_python_inc
import platform
import os.path as p
import ycm_core

DIR_OF_THIS_SCRIPT = p.abspath( p.dirname( __file__ ) )
SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

flags = [
'-Wall',
'-Wextra',
'-Werror',
'-Wno-long-long',
'-Wno-variadic-macros',
'-fexceptions',
'-DNDEBUG',
# THIS IS IMPORTANT! Without the '-x' flag, Clang won't know which language to
# use when compiling headers. So it will guess. Badly. So C++ headers will be
# compiled as C headers. You don't want that so ALWAYS specify the '-x' flag.
# For a C project, you would set this to 'c' instead of 'c++'.
'-x',
'c++',
get_python_inc(),
]

# Clang automatically sets the '-std=' flag to 'c++14' for MSVC 2015 or later,
# which is required for compiling the standard library, and to 'c++11' for older
# versions.
if platform.system() != 'Windows':
    flags.append( '-std=c++11' )

# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# You can get CMake to generate this file for you by adding:
#   set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )
# to your CMakeLists.txt file.
#
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags. Notice that YCM itself uses that approach.
compilation_database_folder = ''

if p.exists( compilation_database_folder ):
    database = ycm_core.CompilationDatabase( compilation_database_folder )
else:
    database = None


def IsHeaderFile( filename ):
    extension = p.splitext( filename )[ 1 ]
    return extension in [ '.h', '.hxx', '.hpp', '.hh' ]

def FindCorrespondingSourceFile( filename ):
    if IsHeaderFile( filename ):
        basename = p.splitext( filename )[ 0 ]
        for extension in SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if p.exists( replacement_file ):
                return replacement_file
    return filename

def Settings( **kwargs ):
    language = kwargs[ 'language' ]

    if language != 'cfamily':
        return {}

    # If the file is a header, try to find the corresponding source file and
    # retrieve its flags from the compilation database if using one. This is
    # necessary since compilation databases don't have entries for header files.
    # In addition, use this source file as the translation unit. This makes it
    # possible to jump from a declaration in the header file to its definition
    # in the corresponding source file.
    filename = FindCorrespondingSourceFile( kwargs[ 'filename' ] )

    if not database:
        return {
                'flags': flags,
                'include_paths_relative_to_dir': DIR_OF_THIS_SCRIPT,
                'override_filename': filename
                }

        compilation_info = database.GetCompilationInfoForFile( filename )
        if not compilation_info.compiler_flags_:
            return {}

    # Bear in mind that compilation_info.compiler_flags_ does NOT return a
    # python list, but a "list-like" StringVec object.
    final_flags = list( compilation_info.compiler_flags_ )

    return {
            'flags': final_flags,
            'include_paths_relative_to_dir': compilation_info.compiler_working_dir_,
            'override_filename': filename
            }

