class SeedDefaultFreePatreonTier < ActiveRecord::Migration[8.1]
  def up
    PatreonTier.reset_column_information
    # Self-host: default tier acts as the highest tier so no feature gates apply.
    PatreonTier.find_or_create_by!(name: "Free") do |tier|
      tier.patreon_tier_id = "free"
      tier.amount_cents    = 0
      tier.published       = true
      tier.book_sync_limit = 1_000_000
      tier.max_book_size   = 10_240 # MB
    end
  end

  def down
    # Intentional no-op: removing this tier would orphan all users who depend on it.
  end
end
