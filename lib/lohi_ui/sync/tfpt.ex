defmodule LohiUi.Sync.Tftp do
  @opts [port: 35234]

  def read_file(remote_filename, local_filename, options),
    do:
      :tftp.read_file(
        String.to_charlist(remote_filename),
        String.to_charlist(local_filename),
        Keyword.merge(@opts, options)
      )

  def write_file(remote_filename, local_filename, options),
    do:
      :tftp.write_file(
        String.to_charlist(remote_filename),
        String.to_charlist(local_filename),
        Keyword.merge(@opts, options)
      )

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {:tftp, :start, [@opts]}
    }
  end
end
