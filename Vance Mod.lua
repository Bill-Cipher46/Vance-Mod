SMODS.Atlas{
  key = 'VanceMod',
  path = 'BigJokers.png',
  px = 414,
  py = 558
}

--Nightmare
SMODS.Joker{
  key = 'Nightmare Vance',
  loc_txt = {
    name = 'Nightmare Vance',
    text = {
      "Retrigger the {C:attention}last{} played",
      "card used in scoring",
      "{C:attention}2{} additional times"
    } 
  },
  
  rarity = 2,
  discovered = true,
  atlas = 'VanceMod',
  pos = {x = 1, y = 0},
  cost = 8,
  
}


--Child -- Done!
SMODS.Joker{
  key = 'Child Vance',
  loc_txt = {
    name = 'Child Vance',
    text = {
      "{C:green}#1# in #2#{} chance to add",
      "{C:edition,T:e_poly}polychrome{} edition to",
      "played and scoring {C:attention}face{} cards"
    } 
  },
  
  rarity = 2,
  atlas = 'VanceMod',
  pos = {x = 2, y = 0},
  cost = 8,
  blueprint_compat = false,
  config = { extra = { odds = 4 } },

  loc_vars = function(self, info_queue, card)
    return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
  end,

  calculate = function(self, card, context)
    if context.before and context.main_eval and not context.blueprint then
      local faces = 0
      for _, scored_card in ipairs(context.scoring_hand) do
        if scored_card:is_face() then
          faces = faces + 1
          scored_card:set_edition('e_polychrome', nil, true)
          G.E_MANAGER:add_event(Event({
            func = function()
              scored_card:juice_up()
              return true
            end
          }))
        end
      end
      if faces > 0 then
        return {
          message = 'Polychrome',
          colour = G.C.EDITION
        }
      end
    end
  end
  
}

--Minion - Done!
SMODS.Joker{
  key = 'Minion Vance',
  loc_txt = {
    name = 'Minion Vance',
    text = {
      "Gain {X:mult,C:white} X#1#{} mult if played hand",
      "contains a {C:attention}Pair{} of {C:attention}Aces",
      "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} mult)"
    }
  },
 
  rarity = 2,
  atlas = 'VanceMod',
  pos = {x = 5, y = 0},
  cost = 6,
  blueprint_compat = true,
  config = { extra = { Xmult = 1, Xmult_gain = 0.2 } },

  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
  end,

  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.Xmult > 1 then
      return{
        x_mult = card.ability.extra.Xmult
      }
    end

    if context.before and next(context.poker_hands['Pair']) and not context.blueprint then
      local aces = 0
      for i = 1, #context.scoring_hand do
        if context.scoring_hand[i]:get_id() == 14 then 
          aces = aces + 1
        end
      end

      if aces >= 2 then
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
          return{
            message = "Thank you",
            colour = G.C.MULT
          }
      end
    end
  end
}

--vegas - Done!
SMODS.Joker{
  key = 'Vegas Sphere Vance',
  loc_txt = {
    name = 'Vegas Sphere Vance',
    text = {
      "Each played {C:attention}7{} gives",
      "{X:mult,C:white}X#1#{} Mult when scored"
    } 
  },
  
  rarity = 2,
  atlas = 'VanceMod',
  pos = {x = 1, y = 1},
  cost = 7,
  blueprint_compat = true,
  
  config = { extra = { Xmult = 1.5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult } }
  end,

  calculate = function(self, card, context)
    if context.cardarea == G.play and context.individual and not context.brainstorm then
      if context.other_card:get_id() == 7 then
        return {
          x_mult = card.ability.extra.Xmult,
          colour = G.C.RED
        }
      end
    end
  end

}

--Engie - Done!
SMODS.Joker{
    key = 'Engie Vance',
    loc_txt = {
      name = 'Engie Vance',
      text = { 
          "Each played and scoring",
          "{C:attention}6{} permanently gains",
          "{C:mult}+#1#{} Mult when scored"
      }
    },

    rarity = 2,
    atlas = 'VanceMod',
    pos = {x=0, y=0},
    cost = 6,
    blueprint_compat = true,

    config = { extra = {perma_mult = 2}},

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.perma_mult}}
    end,

    calculate = function(self, card, context)
      if context.cardarea == G.play and context.individual and not context.brainstorm then
        if context.other_card:get_id() == 6 then
        context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
        context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.perma_mult
        return{
          extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT},
          colour = G.C.MULT,
          card = card
        }
        end
      end
    end

}

--Baby
SMODS.Joker{
  key = 'Baby Vance',
  loc_txt = {
    name = 'Baby Vance',
    text = {
      "{C:mult}+8{} mult and {C:attention}+1{} hand",
      "size. At end of round,",
      "additional {C:mult}+8{} mult",
      "and {C:attention}-1{} hand size"
    } 
  },
  
  rarity = 2,
  atlas = 'VanceMod',
  pos = {x = 3, y = 0},
  cost = 7,
  
}

--Art
SMODS.Joker{
  key = 'Vance Art',
  loc_txt = {
    name = 'Vance Art',
    text = {
      "{C:attention}+1{} hand size for",
      "every consumable in",
      "your consumable slot"
    } 
  },
  
  rarity = 2,
  atlas = 'VanceMod',
  pos = {x = 6, y = 0},
  cost = 6,
  
}

--Emo
SMODS.Joker{
  key = 'Emo Vance',
  loc_txt = {
    name = 'My Chemical RoVance',
    text = {
      "Negative tag?"
    } 
  },
  
  rarity = 4,
  atlas = 'VanceMod',
  pos = {x = 0, y = 1},
  cost = 100,
  
}

--Modok
SMODS.Joker{
  key = 'Modok Vance',
  loc_txt = {
    name = 'Modok Vance',
    text = {
      "TBD"
    } 
  },
  
  rarity = 4,
  atlas = 'VanceMod',
  pos = {x = 2, y = 1},
  cost = 20,
  
}

--Keanu
SMODS.Joker{
  key = 'Keanu Vance',
  loc_txt = {
    name = 'Keanu Vance',
    text = {
      "{C:attention}First two{} played and scoring",
      "cards give {C:white,X:mult}+#1#{} Mult. {C:attention}Third",
      "played and scoring card",
      "gives {C:white,X:mult}+#2#{} Mult"
    } 
  },
  
  rarity = 3,
  atlas = 'VanceMod',
  pos = {x = 3, y = 1},
  cost = 8,
  blueprint_compat = true,
  config = { extra = { nomult = 0, mult = 7 } },

  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.nomult, card.ability.extra.mult } }
  end,

  calculate = function(self, card, context)
    if context.cardarea == G.play then
      local card1 = context.scoring_hand[1]
      local card2 = context.scoring_hand[2]
      local card3 = context.scoring_hand[3]
      
      if context.other_card == card1 or context.other_card == card2 then
        return {
          mult = card.ability.extra.nomult
        }
      end
      if context.other_card == card3 then
        return {
          mult = card.ability.extra.mult
        }
      end

    end
  end
  
}


--Bob - Done!
SMODS.Joker{
  key = 'Bob Vance',
  loc_txt = {
    name = 'Bob Vance',
    text = {
      "Played and scoring",
      "{C:attention,T:#info_queue}Wild Cards{} each",
      "give {X:mult,C:white}X#1#{} mult"
    } 
  },
  
  rarity = 4,
  atlas = 'VanceMod',
  pos = {x = 4, y = 0},
  cost = 20,
  blueprint_compat = true,
  config = { extra = { Xmult = 4 } },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_wild
    return { vars = { card.ability.extra.Xmult} }
  end,

  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.other_card.config.center == G.P_CENTERS.m_wild then
        return{
          x_mult = card.ability.extra.Xmult
        }
      end
    end
  end

}