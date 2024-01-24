
# Register S4 methods
setMethod("initialize", "WrapperConnection", initialize_WrapperConnection)
setMethod("dbConnect", "WrapperDriver", dbConnect_WrapperDriver)
setMethod("dbDisconnect", "WrapperConnection", dbDisconnect_WrapperConnection)
setMethod("dbQuoteIdentifier", c("WrapperConnection", "character"), dbQuoteIdentifier_WrapperConnection)
setMethod("dbQuoteIdentifier", c("WrapperConnection", "SQL"), dbQuoteIdentifier_WrapperConnection)
setMethod("dbGetQuery", c("WrapperConnection", "character"), dbGetQuery_WrapperConnection)
setMethod("dbSendQuery", c("WrapperConnection", "character"), dbSendQuery_WrapperConnection)
setMethod("dbBegin", "WrapperConnection", dbBegin_WrapperConnection)
setMethod("dbCommit", "WrapperConnection", dbCommit_WrapperConnection)
setMethod("dbRollback", "WrapperConnection", dbRollback_WrapperConnection)
setMethod("dbWriteTable", c("WrapperConnection", "character", "ANY"), dbWriteTable_WrapperConnection)

setMethod("initialize", "WrapperResult", initialize_WrapperResult)
setMethod("dbClearResult", "WrapperResult", dbClearResult_WrapperResult)
setMethod("dbFetch", "WrapperResult", dbFetch_WrapperResult)
setMethod("dbHasCompleted", "WrapperResult", dbHasCompleted_WrapperResult)
setMethod("dbGetRowsAffected", "WrapperResult", dbGetRowsAffected_WrapperResult)
