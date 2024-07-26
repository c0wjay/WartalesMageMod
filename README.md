# wartales_wizmod
Wizard Mod for Wartales

대충 생각하고 있는건 한 직업 안에 세가지 트리 쑤셔넣는거고

힐러, 주술사, 법사 이렇게 세가지 트리일듯 (무리다 싶으면 힐러,주술사 두가지 트리 될수도)

기본직업 (Title) : Mage (Magic)  
흑마법사 Warlock / 사제 Priest / 원소술사 Sorcerer

번역작업은 export_zh.xml 참고



# 클래스 기획
## 힐러

의지에 따라서 힐량이 정해짐.

힐링 공식: ( min(skill.unit.stats.willpower, 50)/50 ) * (vars.value1/100) * 2 * randInt(12,20)/16  
전자는 캐릭터의 의지에 영향, 후자는 스킬 레벨에 따라 50, 100과 같이 주기.  
스킬 (타겟힐, 범위힐, 그룹힐)에 따라서 value1 값 차등주기.  
거기에 랜덤 인자 곱 (75 ~ 125% 범위)

레벨링도 고쳐야함.

패시브 고민해야함.


## 주술사

의지에 따라서 디버프/버프 성공률이 정해짐.

주술사는 대충 좁은범위 (radius 1-2, distance 4) 광역 디버프 두가지 (공포, 슬로우나, 공/방 낮추는 커스텀 디버프 만들듯)  
하나는 공포 스택 1-5 중 랜덤 적용, (레벨업 시, 일정 확률로 1턴간 지속되는 Immobile 적용.)  
-> 의지 높을수록 높은 스택 적용될 확룔 높임.

다른 하나는 랜덤 디버프 적용  
( Fragility || Fracture || Weakening || Bruise ) 
레벨업시 일정 확률로 ( Stun ) 적용


아군 버프 생각중.  
(Berserk || BrothersFury || Enervate || 실패)  
레벨업시 일정 확률로 1턴 지속되는 (Arena_Willforce) 적용 // G2Arena1RuleLifeLinked 참고

좀비화도 커스텀 버프인데 대충 베르나 투기장 버프 모티브로,

해당 유닛은 2턴간 피1 밑으로 안떨어지다

2턴 지나면 전투에서 배제되는 그런거 생각중


효과

공포는 콘 모양 + Taunt 모션도 좋을듯
"extraFx": "prefabs/fx/fight/Special/PushingWhooshCone_M2.fx"
"extraFx": "prefabs/fx/fight/Special/PoisonSlashTrail.fx"

디버프 - FogPowder 또는 ConfusingPowder


스킬 효율은 의지 스탯에 영향 받도록 수정.

즉 두가지 팩터에 영향을 받을텐데,

(skill.unit.stats.willpower/100) * (vars.value1/100) * randInt(12,20)/16



# Data CDB Line
- "name": "item"
- "name": "craft"
- "name": "loot"
- "name": "unitClass"
- "name": "unitPattern"
- "name": "skill"
- "name": "status"


# Skill Attribute
```json
{
    "typeStr": "5:TargetUnit,Precision,Passive,Move,Immediate,Zone,WorldPassive",
    "name": "mode"
},
```
typeStr:5 -> 숫자로 계산. 중복 불가. (mode:0 => TargetUnit, 1 => Precision, 2 => Passive, 3 => Move 이런식)

- "group": 2 -> 공용스킬
- "group": 9 -> Swordman
    - Slashes, Estocade / Encouragement, DestabilisingStrike
- "group": 10 -> Bowman
    - Barrage, RecoilShot, ATTACK, AimedShot
- "group": 11 -> Rougue
    - PoisonFlask, Frenzy, SmokeScreen / BetweenTheEyes
- "group": 12 -> Spearman
    - SpearThrow, RallyingShout, SpearsWall, MasteredWhirlwind
- "group": 13 -> Axeman
    - Outburst, SharpWhirlwind, Ovation, PridefulStrike
- "group": 14 -> Brute
    - RelentlessCharge, PoisonedImpact, WeakeningShock, ThunderousBlow

```json
"name": "skill@range"
{
    "typeStr": "5:Enemies,Allies,AlliesWithSelf,Self,All,AllButSelf,None",
    "name": "allowedTargets",
    "opt": true
},
{
    "typeStr": "5:Disc,Cone,Square",
    "name": "type",
    "opt": true
},
```

```json
"name": "skill@props"
{
    "typeStr": "10:IgnoreGuard,DamageHealth,NoFinisher,DontStartUnitTurn,NoPreviewTargets,PushbackIgnoreUnits,DistanceBonusApplied,IsTrap,HideInSkillBar",
    "name": "flags",
    "opt": true
},
```

## props의 특수효과들
- castFx: "히트" 이벤트 또는 애니메이션 끝에서 재생되는 이펙트
- extraFx: 스킬 실행에 추가 이펙트를 재생합니다.
- throwFx: 발사체에 부착된 이펙트
- animFx: 재생된 애니메이션에 해당하는 FX 자동 검색을 대체합니다.


# UnitClass Attribute
props.flags = 2 -> (베이스 직업) Swordman, Bowman, Rogue  
32 -> (전직 직업) Protector, Fighter, Swordmaster, Hunter, BeastMaster, Skirmisher, Cutthroat, Strategist, Poisoner  
2080 -> (전직 직업 중 히든직업) Duellist,  Marksman, Assassin  

아래 unitClass@props 참고.
```json
{
    "typeStr": "10:CanCapture,CanRecruit,CantMakePrisoner,IsChampion,NoEquipDrop,IsSpecialized,IsReserve,ForceDropWeapon,BattleNotCount,CantSurround,LockRotation,IsLocked,HasVisualVariants,GhostUnit,NoWeapon,Plagued,CanTransport,NoPunch,PreventSkilled,ArenaChampion,PreventRenfort",
    "name": "flags",
    "opt": true
},
```
typeStr: 10 -> Binary로 계산, (각각 true/false, 중복가능)

2 = 10 : CanRecruit true  
32 = 100000 : IsSpecialized true  
2080 = 100000100000 : IsSpecialized & IsLocked true  

직업은 tier로 구분  
tier: 0 -> 베이스 직업 (Swordman, Bowman, Rouge 등)  
tier: 1 -> 전직직업 (Swordmaster, BeastMaster 등)  

## Separators
직업간 분리는 아래 "separators" 로 구분선을 만듬.  
skill과 class간 연결은 (unitClass의 seperators.title) 과 (skill의 seperators.title) 가 같으면 됨.  
ex) 검사는 "title": "Sword"

separators.level 은 depth를 의미함.

## Model
- Axeman: Prefab_AS
- Swordman: Prefab_SS
- Rougue: Prefab_D
- Bowman: Prefab_B
- Spearman: Prefab_P
- Brute: Prefab_MS

배정안된 모델들
- Prefab_FS: 로그처럼 보이는 적당한 놈
- Prefab_M,
- Prefab_S,
- Prefab_WP,
- Prefab_WSS, 
- TestAnim, 
- TestChar: 적용하면 크래시남.

# Status Attribute
곰 광폭화: Ténacité sauvage, Berserk  
베르나 투기장 무적: G2Arena1RuleLifeLinked, Arena_Willforce  
도망침 디버프: Terror


# Craft
Craft는 separators가 "id"로 분리하는게 아닌, "index"로 구분함.
즉, 중간에 끼워넣으면 이후 separator index도 1씩 늘려줘야함.
props.disableLoot: 시체에서 루팅 가능한지

```json
item props
{
    "typeStr": "10:HasColor,HideLevel,SexMan,SexWoman,Consumable,UseOnUnit,OneByDayRefill,Upgradable,KeepOnRemove,PrisonersOnly",
    "name": "flags",
    "opt": true
},

```