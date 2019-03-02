class Xraylib < Formula
  desc "Library for interactions of X-rays with matter"
  homepage "https://github.com/tschoonj/xraylib"
  url "https://xraylib.tomschoonjans.eu/xraylib-3.3.0.tar.gz"
  sha256 "a22a73b8d90eb752b034bab1a4cf6abdd81b8c7dc5020bcb22132d2ee7aacd42"

  depends_on "swig" => :build
  depends_on "gcc"
  depends_on "python" => :recommended
  depends_on "fpc" => :optional
  # depends_on "lua" => :optional # currently broken
  depends_on "perl" => :optional
  depends_on "python@2" => :optional
  depends_on "ruby" => :optional

  if build.with?("python@2") || build.with?("python")
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
    #args << (build.with?("lua") ? "--enable-lua" : "--disable-lua")
    args << "--disable-lua"
    args << (build.with?("ruby") ? "--enable-ruby" : "--disable-ruby")
    args << (build.with?("fpc") ? "--enable-pascal" : "--disable-pascal")

    ENV.delete "PYTHONPATH"

    if build.without?("python@2") && build.with?("python")
      args << "--enable-python"
      args << "--enable-python-numpy"
      args << "PYTHON=#{Formula["python"].opt_bin}/python3"
      system "./configure", *args
      system "make"
      system "make", "install"
    elsif build.with?("python@2") && build.without?("python")
      args << "--enable-python"
      args << "--enable-python-numpy"
      args << "PYTHON=#{Formula["python@2"].opt_bin}/python2.7"
      system "./configure", *args
      system "make"
      system "make", "install"
    elsif build.with?("python")
      # build for both python2 and python3 bindings
      # since the configure script allows for only one python binding,
      # some tricks are required here...
      args_nopython = args.dup
      args_python2 = args.dup
      args_python3 = args.dup
      args_nopython << "--disable-python" << "--disable-python-numpy"
      args_python2 << "--enable-python" << "--enable-python-numpy" << "PYTHON=#{Formula["python@2"].opt_bin}/python2.7"
      args_python3 << "--enable-python" << "--enable-python-numpy" << "PYTHON=#{Formula["python"].opt_bin}/python3"

      cd("..") do
        cp_r "xraylib-#{version}", "xraylib-#{version}-python2"
        cp_r "xraylib-#{version}", "xraylib-#{version}-python3"
      end
      system "./configure", *args_nopython
      cd("../xraylib-#{version}-python2") do
        system "./configure", *args_python2
      end
      cd("../xraylib-#{version}-python3") do
        system "./configure", *args_python3
      end
      # build without python first
      system "make"
      # move the configured python directories to the main build dir
      mv "../xraylib-#{version}-python2/python", "python2"
      mv "../xraylib-#{version}-python3/python", "python3"
      # build python2 bindings
      cd("python2") do
        system "make"
      end
      # build python3 bindings
      cd("python3") do
        system "make"
      end
      # install everything except python bindings
      system "make", "install"
      # install python2 bindings
      cd("python2") do
        system "make", "install"
      end
      # finish in style by installing the python3 bindings
      cd("python3") do
        system "make", "install"
      end
    else
      # install without python
      args << "--disable-python" << "--disable-python-numpy"
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <xraylib.h>

      int main()
      {
        double energy = LineEnergy(26, KL3_LINE);
        return 0;
      }
    EOS
    system ENV.cc, "test.c",
                   "-L#{lib}", "-lxrl", "-I#{include}/xraylib", "-o", "test"
    system "./test"
  end
end
