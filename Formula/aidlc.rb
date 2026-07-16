class Aidlc < Formula
  desc "Initialize and update AIDLC governance files"
  homepage "https://github.com/shubhangtiwari/aidlc"
  url "https://github.com/shubhangtiwari/aidlc/archive/refs/tags/aidlc/v0.13.0.tar.gz"
  sha256 "502c63c54de8491409f9523ab5294bcd50a75201c8f4ef1d595a4f8571f127d2"
  license "MIT"

  depends_on "go" => :build

  def install
    cd "aidlc" do
      ldflags = "-s -w -X github.com/shubhangtiwari/aidlc/aidlc/internal/commands.Version=#{version}"
      system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/aidlc"
    end
  end

  test do
    assert_match "aidlc #{version}", shell_output("#{bin}/aidlc version")
  end
end
