class Xraylib < Formula
  desc "Library for interactions of X-rays with matter"
  homepage "https://github.com/tschoonj/xraylib"
  url "https://github.com/tschoonj/xraylib/releases/download/xraylib-4.2.0/xraylib-4.2.0.tar.xz"
  sha256 "1ec79973e2abcc372e26add7bd911f54c741699511e16fb64841f1c809969ee2"

  depends_on "swig" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc"
  depends_on "python@3.13" => :recommended
  depends_on "fpc" => :optional
  depends_on "lua" => :optional
  depends_on "perl" => :optional
  depends_on "ruby" => :optional

  if build.with?("python@3.13")
    depends_on "cython" => :build
    depends_on "numpy"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-idl
      --disable-php
      --disable-java
      --enable-fortran2003
    ]

    args << (build.with?("perl") ? "--enable-perl" : "--disable-perl")
    args << (build.with?("ruby") ? "--enable-ruby" : "--disable-ruby")
    args << (build.with?("fpc") ? "--enable-pascal" : "--disable-pascal")

    if build.with?("python@3.13")
      args << "--enable-python"
      args << "--enable-python-numpy"
      args << "PYTHON=#{Formula["python@3.13"].opt_bin}/python3.13"
    else
      args << "--disable-python"
      args << "--disable-python-numpy"
    end
    system "autoreconf", "-i"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <xraylib.h>

      int main()
      {
        double energy = LineEnergy(26, KL3_LINE, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c",
                   "-L#{lib}", "-lxrl", "-I#{include}/xraylib", "-o", "test"
    system "./test"
  end
end
