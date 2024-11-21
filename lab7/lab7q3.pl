:- dynamic character/7.

character_description -->
    [Type, Subtype, Sequence, HealthLevel, Weapon, MovementStyle],
    {
        validate_type(Type),
        validate_subtype(Type, Subtype),
        validate_health(HealthLevel),
        validate_weapon(Type, Weapon),
        validate_movement_style(MovementStyle),
        determine_movement_direction(Type, Weapon, MovementDirection),
        assert_character(Type, Subtype, Sequence, MovementDirection, HealthLevel, Weapon, MovementStyle)
    }.


determine_movement_direction(enemy, _, towards).
determine_movement_direction(hero, has_weapon, towards).
determine_movement_direction(hero, no_weapon, away).


validate_type(Type) :-
    member(Type, [enemy, hero]).

validate_subtype(Type, Subtype) :-
    Type == enemy, member(Subtype, [darkwizard, demon, basilisk]);
    Type == hero, member(Subtype, [wizard, mage, elf]).

validate_health(HealthLevel) :-
    member(HealthLevel, [very_weak, weak, normal, strong, very_strong]).

validate_weapon(hero, Weapon) :-
    member(Weapon, [has_weapon, no_weapon]).
validate_weapon(enemy, no_weapon).

validate_movement_style(MovementStyle) :-
    member(MovementStyle, [jerky, stealthy, smoothly]).


assert_character(Type, Subtype, Sequence, MovementDirection, HealthLevel, Weapon, MovementStyle) :-
    assert(character(Type, Subtype, Sequence, MovementDirection, HealthLevel, Weapon, MovementStyle)).


get_character(Sequence, Type, Subtype, MovementDirection, HealthLevel, Weapon, MovementStyle) :-
    character(Type, Subtype, Sequence, MovementDirection, HealthLevel, Weapon, MovementStyle).


