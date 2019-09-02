# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "gdk-pixbuf"
version = v"2.36.12"

sources = [
    "http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.12.tar.xz" =>
    "fff85cf48223ab60e3c3c8318e2087131b590fd6f1737e42cb3759a3b427a334",
]

# Bash recipe for building across all platforms
# TODO: Theora and Opus once their releases are available
script = raw"""
cd $WORKSPACE/srcdir
cd gdk-pixbuf-2.36.12/
export CPPFLAGS="-I${prefix}/include"
./configure --prefix=$prefix --host=$target --with-x11
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, ["libgdk"], :gdk),
    LibraryProduct(prefix, ["libgdk_pixbuf"], :gdk_pixbuf),
]

# Dependencies that must be installed before this package can be built
# Based on http://www.linuxfromscratch.org/blfs/view/8.3/x/gdk-pixbuf.html
dependencies = [
    "https://github.com/giordano/Yggdrasil/releases/download/X11-v1.6.8/build_X11.v1.6.8.jl",
    # Glib-related dependencies
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/PCRE-v8.42-2/build_PCRE.v8.42.0.jl",
    "https://github.com/giordano/Yggdrasil/releases/download/Libffi-v3.2.1-0/build_Libffi.v3.2.1.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Libiconv-v1.15-0/build_Libiconv.v1.15.0.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Gettext-v0.19.8-0/build_Gettext.v0.19.8.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Glib-v2.59.0%2B0/build_Glib.v2.59.0.jl",

    "https://github.com/JuliaIO/LibpngBuilder/releases/download/v1.0.3/build_libpng.v1.6.37.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/JpegTurbo-v2.0.1-0/build_JpegTurbo.v2.0.1.jl",
    "https://github.com/JuliaIO/LibTIFFBuilder/releases/download/v6/build_libtiff.v4.0.9.jl",
    "https://github.com/ianshmean/SharedMimeInfoBuilder/releases/download/v1.0.0/build_shared-mime-info.v1.10.0.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
