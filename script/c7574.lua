--不知火流 輪廻の陣
--Shiranui Style Reincarnation
--Scripted by Eerie Code
function c7574.initial_effect(c)
	--change code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetValue(40005099)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c7574.target1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c7574.target2)
	c:RegisterEffect(e2)
end

function c7574.ndcfil(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()
end
function c7574.ndcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7574.ndcfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(7574)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c7574.ndcfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(7574,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c7574.ndop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function c7574.drfil(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:GetDefense()==0 and c:IsAbleToDeck()
end
function c7574.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(7574)==0 end
	e:GetHandler():RegisterFlagEffect(7574,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)	
end
function c7574.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c7574.drfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7574.drfil,tp,LOCATION_REMOVED,0,2,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c7574.drfil,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c7574.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g,p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Draw(p,d,REASON_EFFECT)
	end
end

function c7574.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=c7574.ndcost(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c7574.drcost(e,tp,eg,ep,ev,re,r,rp,0) and c7574.drtg(e,tp,eg,ep,ev,re,r,rp,0)
	local op=2
	e:SetCategory(0)
	e:SetProperty(0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(7574,0),aux.Stringid(7574,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(7574,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(7574,1))+1
		end
		if op==0 then
			e:SetCategory(0)
			e:SetProperty(0)
			c7574.ndcost(e,tp,eg,ep,ev,re,r,rp,1)
			Duel.BreakEffect()
			e:SetOperation(c7574.ndop)
		else
			e:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
			c7574.drcost(e,tp,eg,ep,ev,re,r,rp,1)
			c7574.drtg(e,tp,eg,ep,ev,re,r,rp,1)
			Duel.BreakEffect()
			e:SetOperation(c7574.drop)
		end
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end

function c7574.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=c7574.ndcost(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c7574.drcost(e,tp,eg,ep,ev,re,r,rp,0) and c7574.drtg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(7574,0),aux.Stringid(7574,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(7574,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(7574,1))+1
	end
	if op==0 then
		e:SetCategory(0)
		e:SetProperty(0)
		c7574.ndcost(e,tp,eg,ep,ev,re,r,rp,1)
		Duel.BreakEffect()
		e:SetOperation(c7574.ndop)
	else
		e:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
		c7574.drcost(e,tp,eg,ep,ev,re,r,rp,1)
		c7574.drtg(e,tp,eg,ep,ev,re,r,rp,1)
		Duel.BreakEffect()
		e:SetOperation(c7574.drop)
	end
end
