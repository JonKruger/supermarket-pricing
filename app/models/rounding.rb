module Rounding
  def round_money(amount)
    (amount.to_f * 100).round.to_f / 100
  end
end


