-- Création de la vue pour les prix des options
CREATE OR REPLACE VIEW OptionPrices AS
SELECT
    c.client_id,
    s.stock_id,
    m.mc_option_price_put AS monte_carlo_put_price,
    m.mc_option_price_call AS monte_carlo_call_price,
    b.call_option_price AS black_scholes_call_price,
    b.put_option_price AS black_scholes_put_price
FROM Clients c
JOIN Wallets w ON c.client_id = w.client_id
JOIN Options o ON w.wallet_id = o.wallet_id
JOIN Stocks s ON o.stock_symbol = s.stock_symbol
CROSS JOIN LATERAL (
    SELECT
        mc_option_price_put,
        mc_option_price_call
    FROM monte_carlo_simulation_proc(
        100.0, -- Prix actuel de l'action
        0.05, -- Taux de rendement attendu
        0.20, -- Volatilité
        1.0, -- Durée jusqu'à l'expiration de l'option (en années)
        0.03, -- Taux d'intérêt sans risque
        1000, -- Nombre de simulations
        252, -- Nombre d'étapes dans la simulation
        105.0 -- Prix d'exercice de l'option
    )
) m
CROSS JOIN LATERAL (
    SELECT
        call_option_price,
        put_option_price
    FROM black_scholes_option_pricing(
        100.0, -- Prix actuel de l'action
        105.0, -- Prix d'exercice de l'option
        1.0, -- Durée jusqu'à l'expiration de l'option (en années)
        0.05, -- Taux d'intérêt sans risque
        0.20 -- Volatilité
    )
) b;

-- Exemples de requêtes utilisant la vue
SELECT * FROM OptionPrices WHERE client_id = 1; -- Remplacer par l'ID du client souhaité

-- Exemple de requête pour afficher les prix des options pour le client avec l'ID 1
SELECT * FROM OptionPrices WHERE client_id = 1;
