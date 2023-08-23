class H2 < Formula
  desc "Java SQL database"
  homepage "https://www.h2database.com/"
  url "https://github.com/h2database/h2database/releases/download/version-2.2.222/h2-2023-08-22.zip"
  version "2.2.222"
  sha256 "0dcc343523f2d52b505b1eecb95143132d2fa1222029597eb572d4a3c0d06535"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "511aca0c6b46a789986c1c7b93f62a820e5c7c2b3872e396b3fe80377d5e161a"
  end

  depends_on "openjdk"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the script
    # upstream issue, https://github.com/h2database/h2database/issues/3254
    chmod 0755, "bin/h2.sh"

    libexec.install Dir["*"]
    (bin/"h2").write_env_script libexec/"bin/h2.sh", Language::Java.overridable_java_home_env
  end

  service do
    run [opt_bin/"h2", "-tcp", "-web", "-pg"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "Usage: java org.h2.tools.GUIConsole", shell_output("#{bin}/h2 -help 2>&1")
  end
end
