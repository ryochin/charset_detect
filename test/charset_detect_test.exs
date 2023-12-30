defmodule CharsetDetectTest do
  use ExUnit.Case
  doctest CharsetDetect

  %{
    big5: "Big5",
    cp932: "Shift_JIS",
    eucjp: "EUC-JP",
    gbk: "GBK",
    jis: "ISO-2022-JP",
    sjis: "Shift_JIS",
    utf8: "UTF-8"
  }
  |> Enum.each(fn {input, result} ->
    @input input
    @result result

    test "#{input} encoding" do
      assert {:ok, @result} = CharsetDetect.guess(File.read!("test/assets/#{@input}.txt"))
    end
  end)

  test "empty string" do
    assert {:ok, "UTF-8"} = CharsetDetect.guess("")
  end

  test "nil" do
    assert {:error, "invalid argument"} = CharsetDetect.guess(nil)
  end
end
