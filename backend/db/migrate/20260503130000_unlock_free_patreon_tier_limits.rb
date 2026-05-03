class UnlockFreePatreonTierLimits < ActiveRecord::Migration[8.1]
  def up
    PatreonTier.reset_column_information
    tier = PatreonTier.find_by(name: "Free")
    tier&.update!(book_sync_limit: 1_000_000, max_book_size: 10_240)
  end

  def down
    # No-op: we don't restore the previous (lower) limits.
  end
end
