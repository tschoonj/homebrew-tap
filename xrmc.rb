class Xrmc < Formula
  desc "Monte Carlo simulation of X-ray imaging and spectroscopy experiments"
  homepage "https://github.com/golosio/xrmc"
  url "https://xrmc.tomschoonjans.eu/xrmc-6.7.0.tar.gz"
  sha256 "03d4cbcb33c7fb59bd9397ad58524687ef7b05bd62dd67fc0b36497ba47d8ccf"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "xraylib"
  depends_on "llvm"
  depends_on "xmi-msim" => :optional

  def install
    ENV['CC'] = Formula["llvm"].opt_bin/"clang"
    ENV['CXX'] = Formula["llvm"].opt_bin/"clang++"
    ENV['LDFLAGS'] = "-L#{Formula["llvm"].opt_lib} -Wl,-rpath,#{Formula["llvm"].opt_lib}"
    ENV['CPPFLAGS'] = "-isysroot #{MacOS.sdk_path}"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-openmp
      --docdir=#{doc}
      --datarootdir=#{pkgshare}
    ]

    if build.with? "xmi-msim"
      args << "--enable-xmi-msim"
    else
      args << "--disable-xmi-msim"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    cp_r (pkgshare/"examples/cylind_cell").children, testpath
    system bin/"xrmc", "input.dat"
  end
end
