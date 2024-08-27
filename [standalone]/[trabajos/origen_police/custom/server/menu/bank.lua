function GetPlayerBankNumber(identifier, qbAccount)
    return qbAccount and qbAccount or "XXXXXXXXX"
end
exports("GetPlayerBankNumber", GetPlayerBankNumber)