class Polycap < Formula
  desc "Ray-tracing polycapillaries using Monte Carlo simulations"
  homepage "https://github.com/PieterTack/polycap"
  url "https://github.com/PieterTack/polycap/releases/download/v1.0/polycap-1.0.tar.gz"
  sha256 "e181378eb3eb3479e87cdedc8bfb326e524999abf06b99e3a1a9528ba4f0608b"

  depends_on "pkg-config" => :build
  depends_on "easyrng"
  depends_on "gcc"
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "llvm"
  depends_on "xraylib"

  depends_on "python@3.8" => :recommended

  if build.with?("python@3.8")
    depends_on "cython" => :build
    depends_on "numpy"
  end

  def install
    ENV["CC"] = Formula["llvm"].opt_bin/"clang"
    ENV["LDFLAGS"] = "-L#{Formula["llvm"].opt_lib} -Wl,-rpath,#{Formula["llvm"].opt_lib}"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    if build.with?("python@3.8")
      args << "--enable-python"
      args << "PYTHON=#{Formula["python@3.8"].opt_bin}/python3"
    else
      args << "--disable-python"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    Pathname("test.py").write <<~EOS
      import polycap
      assert(polycap.__version__ == b"#{version}")
    EOS

    pyversion = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", "test.py"
  end
end
