class Aidlc < Formula
  desc "Initialize and update AIDLC governance files"
  homepage "https://github.com/shubhangtiwari/aidlc"
  url "https://github.com/shubhangtiwari/aidlc/archive/refs/tags/aidlc/v0.10.0.tar.gz"
  sha256 "e3e0f94a9fa13db52212922c3f51cae2f3ff1d67c56c84ed23017a5293a9e825"
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
