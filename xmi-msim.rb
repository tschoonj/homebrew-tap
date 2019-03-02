class XmiMsim < Formula
  desc "Monte Carlo simulation of X-ray fluorescence spectrometers"
  homepage "https://github.com/tschoonj/xmimsim"
  url "https://xmi-msim.tomschoonjans.eu/xmimsim-7.0.tar.gz"
  sha256 "3e970203a56a116fe0b136a857b91b6c4f001cb69b6ac8f68bd865bb7c688542"

  depends_on "pkg-config" => :build
  depends_on "fgsl"
  depends_on "gcc"
  depends_on "glib"
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "xraylib"

  def install
    ENV.deparallelize # fortran modules don't like parallel builds

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gui",
                          "--disable-updater",
                          "--disable-mac-integration",
                          "--disable-libnotify"
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
