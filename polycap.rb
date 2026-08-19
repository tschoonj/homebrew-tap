class Polycap < Formula
  desc "Ray-tracing polycapillaries using Monte Carlo simulations"
  homepage "https://github.com/PieterTack/polycap"
  url "https://github.com/PieterTack/polycap/releases/download/v1.2/polycap-1.2.tar.xz"
  sha256 "6e08a8f5ae29f7948a10aa75806bbf11a401ac735de903d4c574b22c25b18dce"
  revision 2

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "easyrng"
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "llvm"
  depends_on "xraylib"

  depends_on "python@3.14" => :recommended

  if build.with?("python@3.14")
    depends_on "cython" => :build
    depends_on "numpy"
  end

  def install
    ENV["CC"] = Formula["llvm"].opt_bin/"clang"
    ENV["CPPFLAGS"] = "-I#{Formula["hdf5"].opt_include}"
    ENV["LDFLAGS"] = "-L#{Formula["llvm"].opt_lib} -Wl,-rpath,#{Formula["llvm"].opt_lib}"

    args = ["-Dbuild-documentation=false", "--libdir=lib"]

    if build.with?("python@3.14")
      site_packages = prefix/Language::Python.site_packages("python3.14")

      args << "-Dpython.platlibdir=#{site_packages}"
      args << "-Dpython.purelibdir=#{site_packages}"
      args << "-Dbuild-python-bindings=true"
      args << "-Dpython=#{Formula["python@3.14"].opt_bin}/python3.14"
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
      assert(polycap.__version__ == "#{version}")
    EOS

    pyversion = Language::Python.major_minor_version Formula["python@3.14"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
    system Formula["python@3.14"].opt_bin/"python3", "test.py"
  end
end
