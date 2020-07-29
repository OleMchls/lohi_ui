require Logger

{:ok, hostname} = :inet.gethostname()
Node.start(:"nerves@#{hostname}.")
