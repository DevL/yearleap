defmodule LeapYear do
  import Guardsafe, only: [divisible_by?: 2]

  @doc """
  Determines whether a year is a leap year or not.
  """
  @spec leap_year?(integer) :: boolean
  def leap_year?(year) when divisible_by?(year, 400), do: true
  def leap_year?(year) when divisible_by?(year, 100), do: false
  def leap_year?(year), do: divisible_by?(year, 4)
end
