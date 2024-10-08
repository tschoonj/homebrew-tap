class Easyrng < Formula
  desc "Random number generators and distributions for C and Fortran"
  homepage "https://tschoonj.github.io/easyRNG"
  url "https://github.com/tschoonj/easyRNG/releases/download/easyRNG-1.2/easyRNG-1.2.tar.gz"
  sha256 "56259ae12ebb9133e55783b24b8d1a70a59df47f5b1f1485fd689a014b964072"
  revision 7

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gcc"

  def install
    gcc = Formula["gcc"]
    ENV['CC'] = "#{gcc.opt_bin}/gcc-14"
    ENV['CXX'] = "#{gcc.opt_bin}/g++-14"
    ENV['FC'] = "#{gcc.opt_bin}/gfortran-14"
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "true"
  end
end
