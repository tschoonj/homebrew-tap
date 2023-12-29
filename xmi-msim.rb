class XmiMsim < Formula
  desc "Monte Carlo simulation of X-ray fluorescence spectrometers"
  homepage "https://github.com/tschoonj/xmimsim"
  url "https://xmi-msim.tomschoonjans.eu/xmimsim-8.1.tar.gz"
  sha256 "15f011acf8de9bcd64103aae4054d00e4731c6ce2a16a5724039be0e6de1b66d"
  revision 4

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "easyrng"
  depends_on "gcc"
  depends_on "glib"
  depends_on "hdf5"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "xraylib"
  depends_on "libsoup"
  depends_on "gtkmm-plplot"
  depends_on "libpeas"
  depends_on xcode: :build

  patch :DATA

  def install
    ENV.deparallelize # fortran modules don't like parallel builds

    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-gui",
                          "--disable-google-analytics",
                          "--disable-updater"
    system "make", "install"
  end

  def post_install
    ohai "Generating xmimsimdata.h5 – this may take a while"
    mktemp do
      system bin/"xmimsim-db"
      (share/"xmimsim").install "xmimsimdata.h5"
    end
  end

  test do
    system bin/"xmimsim", "--version"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index dc22c96..b18df80 100644
--- a/configure.ac
+++ b/configure.ac
@@ -275,18 +275,6 @@ if test "x$enable_google_analytics" != xno ; then
 fi
 AM_CONDITIONAL([ENABLE_GOOGLE_ANALYTICS],[test "x$GOOGLE_ANALYTICS_FOUND" = xyes])

-# quicklook support -> need GTKmm3 and PLplot!
-QUICKLOOK_DEPS_FOUND=
-if test "x$GTK_FOUND" = xyes ; then
-	PKG_CHECK_MODULES(QUICKLOOK, cairo-quartz libxml-2.0 plplot,[
-		QUICKLOOK_DEPS_FOUND=yes
-		AC_MSG_NOTICE([Building with Quicklook support])
-	], [
-		QUICKLOOK_DEPS_FOUND=no
-	])
-fi
-AM_CONDITIONAL([ENABLE_QUICKLOOK],[test "x$QUICKLOOK_DEPS_FOUND" = xyes])
-
 #check for headers
 AC_CHECK_HEADER(stdio.h,,[AC_MSG_ERROR([Required header not found on the system])])
 AC_CHECK_HEADER(errno.h,,[AC_MSG_ERROR([Required header not found on the system])])
@@ -630,7 +618,6 @@ AC_CONFIG_FILES([ 	Makefile
 			libxmimsim.pc
 			osx/Makefile
 			osx/Info.plist
-			osx/quicklook/Makefile
 			custom-detector-response/Makefile
 			examples/Makefile
 			tests/Makefile
diff --git a/osx/Makefile.am b/osx/Makefile.am
index 312be63..c1f2628 100644
--- a/osx/Makefile.am
+++ b/osx/Makefile.am
@@ -13,7 +13,5 @@
 #You should have received a copy of the GNU General Public License
 #along with this program.  If not, see <http://www.gnu.org/licenses/>.

-SUBDIRS = quicklook
-
 EXTRA_DIST = Info.plist.in

diff --git a/src/Makefile.am b/src/Makefile.am
index a99606b..685af34 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -137,7 +137,7 @@ xmimsim_metal_la_LDFLAGS += -Wl,-headerpad_max_install_names
 endif

 %.air : %.metal
-	$(AM_V_GEN) xcrun --sdk macosx metal $(AM_CPPFLAGS) $(CPPFLAGS) -I${srcdir} -c $< -o $@
+	$(AM_V_GEN) xcrun --sdk macosx metal $(AM_CPPFLAGS) $(CPPFLAGS) -I${srcdir} -D__METAL_MACOS__ -c $< -o $@

 %.metallib : %.air
 	$(AM_V_GEN) xcrun --sdk macosx metallib $< -o $@
@@ -171,31 +171,6 @@ libxmimsim_google_analytics_la_LIBADD = @GOOGLE_ANALYTICS_LIBS@
 libxmimsim_la_LIBADD += libxmimsim-google-analytics.la
 endif

-# quicklook plugin library for macOS bundle
-if ENABLE_QUICKLOOK
-noinst_LTLIBRARIES += libxmimsim-ql.la
-libxmimsim_ql_la_SOURCES = \
-	xmi_xml.c \
-	xmi_data_structs.c \
-	xmi_lines.h \
-	xmi_lines.c
-libxmimsim_ql_la_CPPFLAGS = -DQUICKLOOK=1 \
-	-I${top_srcdir}/include -I${top_builddir}/include
-libxmimsim_ql_la_CFLAGS = \
-	@xml2_CFLAGS@ \
-	@glib2_CFLAGS@ \
-	@xraylib_CFLAGS@ \
-	@libsoup_CFLAGS@ \
-	@WSTRICT_CFLAGS@
-libxmimsim_ql_la_LIBADD = \
-	@xml2_LIBS@ \
-	@glib2_LIBS@
-libxmimsim_ql_la_LDFLAGS = \
-	-shared \
-	-Wl,-headerpad_max_install_names \
-	-framework CoreFoundation
-endif
-
 xmi_resources.c: xmi.gresource.xml $(shell $(GLIB_COMPILE_RESOURCES) --sourcedir=$(srcdir) --generate-dependencies $(srcdir)/xmi.gresource.xml)
 	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(srcdir) --c-name=xmi --generate-source $(srcdir)/xmi.gresource.xml


