class XmiMsim < Formula
  desc "Monte Carlo simulation of X-ray fluorescence spectrometers"
  homepage "https://github.com/tschoonj/xmimsim"
  url "https://xmi-msim.tomschoonjans.eu/xmimsim-8.0.tar.gz"
  sha256 "0fc493c08a75485cc73ee8969285c27b567ad51c25ef51b3bab650cc941f9064"

  depends_on "pkg-config" => :build
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

  def install
    ENV.deparallelize # fortran modules don't like parallel builds

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-gui",
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
