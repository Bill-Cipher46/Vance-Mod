SMODS.Atlas{
  key = 'VanceMod',
  path = 'BigJokers.png',
  px = 414,
  py = 558
}

--Keanu - done!
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
  
  rarity = 1,
  atlas = 'VanceMod',
  pos = {x = 3, y = 1},
  cost = 6,
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
          mult_mod = card.ability.extra.nomult,
          colour = G.C.MULT,
          message = "+0"
        }
      end
      if context.other_card == card3 then
        return {
          mult_mod = card.ability.extra.mult,
          colour = G.C.MULT,
          message = "+7"
        }
      end
    end
  end
  
}


--Child -- Done!
SMODS.Joker{
  key = 'Child Vance',
  loc_txt = {
    name = 'Child Vance',
    text = {
      "{C:green}#1# in #2#{} chance to add",
      "{C:edition,T:info_queue[1]}polychrome{} edition to",
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
    info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
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
  perishable_compat = false,
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

--Nightmare - done!
SMODS.Joker{
  key = 'Nightmare Vance',
  loc_txt = {
    name = 'Nightmare Vance',
    text = {
      "Retrigger the {C:attention}last{} played",
      "card used in scoring",
      "{C:attention}#1#{} additional times"
    } 
  },
  
  rarity = 2,
  atlas = 'VanceMod',
  pos = {x = 1, y = 0},
  cost = 6,
  blueprint_compat = true,
  config = {
    extra = {
      repetitions = 2
    }
  },

  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.repetitions
      }
    }
  end,

  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[#context.scoring_hand] then
      return {
        repetitions = card.ability.extra.repetitions
      }
    end
  end
  
}

--lil - done!
SMODS.Joker{
  key = 'lil',
  loc_txt = {
    name = 'Lil Vance',
    text = {
      "Gain {C:mult}+#1#{} Mult if played and",
      "scoring hand contains only",
      "cards of rank {C:attention}5{} or lower",
      "{C:inactive}(Currently {C:mult}+#2#{} Mult)"
    } 
  },
  
  rarity = 2,
  atlas = 'VanceMod',
  pos = {x = 3, y = 0},
  cost = 6,
  blueprint_compat = false,
  eternal_compat = false,
  perishable_compat = false,
  config = {
    extra = {
      mult_gain = 2,
      mult = 0
    }
  },

  loc_vars = function(self, info_queue, card)
    return{
      vars = {
        card.ability.extra.mult_gain,
        card.ability.extra.mult
      }
    }
  end,

  calculate = function(self, card, context)
    if context.before and context.main_eval and not context.blueprint then
      local bigCards = false
      for k, v in ipairs(context.scoring_hand) do
        if v:get_id() > 5 then
          bigCards = true
        end
      end
      if bigCards == false then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
      end
    end

    if context.joker_main then
      return {
        mult = card.ability.extra.mult
      }
    end
  end
  
}

--Art - done!
SMODS.Joker{
  key = 'Vance Art',
  loc_txt = {
    name = 'Vance Art',
    text = {
      "All played {C:attention}number{} cards",
      "become {C:attention,T:info_queue[1]}Wild{} cards",
      "when scored",
    } 
  },
  
  rarity = 2,
  atlas = 'VanceMod',
  pos = {x = 6, y = 0},
  cost = 5,
  blueprint_compat = false,

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
  end,

  calculate = function(self, card, context)
    if context.before and context.main_eval and not context.blueprint then
      local numbers = 0
      for _, scored_card in ipairs(context.scoring_hand) do
        if not scored_card:is_face() then
          numbers = numbers + 1
          scored_card:set_ability('m_wild', nil, true)
          G.E_MANAGER:add_event(Event({
            func = function()
              scored_card:juice_up()
              return true
            end
          }))
        end
      end
      if numbers > 0 then
        return {
          message = "Wild",
          colour = G.C.EDITION
        }
      end
    end
  end
  
}

--Modok - done!
SMODS.Joker{
  key = 'Modok Vance',
  loc_txt = {
    name = 'Modok Vance',
    text = {
      "{C:mult}+#1#{} Mult for each",
      "{C:attention}Blind{} skipped this run",
      "{C:inactive}(Currently {C:mult}+#2#{} Mult)"
    } 
  },
  
  rarity = 2,
  atlas = 'VanceMod',
  pos = {x = 2, y = 1},
  cost = 5,
  config = {
    extra = {
      mult = 10
    }
  },

  loc_vars = function(self, info_queeu, card)
    return{
      vars = {
        card.ability.extra.mult,
        G.GAME.skips * card.ability.extra.mult
      }
    }
  end,

  calculate = function(self, card, context)
    if context.skip_blind and not context.blueprint then
      return {
        message = localize { type = 'variable', key = 'a_mult', vars = { G.GAME.skips * card.ability.extra.mult } },
        colour = G.C.MULT
      }
    end
    if context.joker_main then
      return {
        mult = G.GAME.skips * card.ability.extra.mult
      }
    end
  end
  
}


--Emo - done!
SMODS.Joker{
  key = 'Emo Vance',
  loc_txt = {
    name = 'My Chemical RoVance',
    text = {
      "Gain a free {C:dark_edition,T:info_queue[1]}Negative{} tag",
      "after playing {C:attention}#1#{} consecutive",
      "hands with less than {C:attention}#2#{} cards",
      "{C:inactive}(Currently {C:attention}#3#{C:inactive}/#1#)"
    } 
  },
  
  rarity = 3,
  atlas = 'VanceMod',
  pos = {x = 0, y = 1},
  cost = 9,
  config = {
    extra = {
      emo_hands = 0,
      cards = 3,
      total_hands = 3
    }
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = { key = 'tag_negative', set = 'Tag' }
    return{
      vars = {
        card.ability.extra.total_hands,
        card.ability.extra.cards,
        card.ability.extra.emo_hands
      }
    }
  end,

  calculate = function(self, card, context)
    if context.joker_main and #context.full_hand < card.ability.extra.cards then
      card.ability.extra.emo_hands = card.ability.extra.emo_hands + 1
      return {
        message = (card.ability.extra.emo_hands < card.ability.extra.total_hands) and
          (card.ability.extra.emo_hands .. '/' .. card.ability.extra.total_hands) or
          localize('k_active_ex'),
        colour = G.C.FILTER
      }
    else
      if context.joker_main and card.ability.extra.emo_hands > 0 then
        card.ability.extra.emo_hands = 0
        return {
          message = localize('k_reset')
        }
      end
    end

    if card.ability.extra.emo_hands >= card.ability.extra.total_hands then
      card.ability.extra.emo_hands = 0
      G.E_MANAGER:add_event(Event({
        func = (function()
          add_tag(Tag('tag_negative'))
          play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
          play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
          return true
        end)
      }))
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