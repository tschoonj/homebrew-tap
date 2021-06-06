class Xraylib < Formula
  desc "Library for interactions of X-rays with matter"
  homepage "https://github.com/tschoonj/xraylib"
  url "https://xraylib.tomschoonjans.eu/xraylib-4.1.0.tar.gz"
  sha256 "3b6b07118153369f8d55b197fa8f341e38cb5fabc611deb576d2c805be5db7c4"

  depends_on "swig" => :build
  depends_on "gcc"
  depends_on "python@3.9" => :recommended
  depends_on "fpc" => :optional
  depends_on "lua" => :optional
  depends_on "perl" => :optional
  depends_on "ruby" => :optional

  if build.with?("python@3.9")
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

    if build.with?("python@3.9")
      args << "--enable-python"
      args << "--enable-python-numpy"
      args << "PYTHON=#{Formula["python@3.9"].opt_bin}/python3"
    else
      args << "--disable-python"
      args << "--disable-python-numpy"
    end
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
