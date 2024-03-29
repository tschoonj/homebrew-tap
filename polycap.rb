class Polycap < Formula
  desc "Ray-tracing polycapillaries using Monte Carlo simulations"
  homepage "https://github.com/PieterTack/polycap"
  url "https://github.com/PieterTack/polycap/releases/download/v1.1/polycap-1.1.tar.gz"
  sha256 "4c15c260b00d1c0036df54016e646e25fcc8a333a29ab703a017bd674dadc04b"
  revision 3

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "easyrng"
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "llvm"
  depends_on "xraylib"

  depends_on "python@3.11" => :recommended

  if build.with?("python@3.11")
    depends_on "cython" => :build
    depends_on "numpy"
  end

  def install
    ENV["CC"] = Formula["llvm"].opt_bin/"clang"
    ENV["CPPFLAGS"] = "-I#{Formula["hdf5"].opt_include}"
    ENV["LDFLAGS"] = "-L#{Formula["llvm"].opt_lib} -Wl,-rpath,#{Formula["llvm"].opt_lib}"

    args = ["-Dbuild-documentation=false"]

    if build.with?("python@3.11")
      args << "-Dbuild-python-bindings=true"
      args << "-Dpython=#{Formula["python@3.11"].opt_bin}/python3.11"
    else
      args << "-Dbuild-python-bindings=false"
    end

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import polycap
      assert(polycap.__version__ == b"#{version}")
    EOS

    pyversion = Language::Python.major_minor_version Formula["python@3.11"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
    system Formula["python@3.10"].opt_bin/"python3", "test.py"
  end
end
