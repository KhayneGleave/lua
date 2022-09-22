//NOT COMPLETED

const request = require('request');
let Ancestor = {

    SessionID: 'SESSION_ID_HERE', //Will need to change upon every browser reload/ expired session notice!

}

Ancestor.SendItemToClub = function(ItemID){

    return new Promise(resolve => {

        request({

            url: 'https://utas.mob.v1.fut.ea.com/ut/game/fifa23/item',
            method: 'PUT',
            body: '{"itemData":[{"id":' + ItemID +',"pile":"club"}]}',
            headers: {'X-UT-SID': Ancestor.SessionID}

        }, function(error, response, body) {

            try {

                let ItemDetails = JSON.parse(body)

                console.log(ItemDetails.itemData[0].success == false && 'Action Failed' || 'Action Completed')

            }catch {

                console.warn(error || body || 'an error occurred')

            } finally {
                resolve()
            }

        })

    })

}

Ancestor.QuicksellItem = function(Item_ID, Amount){

    return new Promise(resolve =>{

        request({

            url: 'https://utas.mob.v1.fut.ea.com/ut/game/fifa23/item/' + Item_ID.toString(),
            method: 'DELETE',
            headers: {'X-UT-SID': Ancestor.SessionID}

        }, (error, response, body) => {

            try{

                console.log((response.statusCode == 200 && 'Quick Sold: ' + Item_ID.toString()) || 'fucky')

            }catch {

                console.warn(error || body || 'an error occured')

            }finally {

                resolve()

            }

        })

    })

}

Ancestor.SendToTransferList = function(Item_ID) {

    return new Promise(resolve => {

            request({

            url: 'https://utas.mob.v1.fut.ea.com/ut/game/fifa23/item',
            method: 'PUT',
            body: '{"itemData":[{"id":' + Item_ID +',"pile":"trade"}]}',
            headers: {'X-UT-SID': Ancestor.SessionID}

        }, (error, response, body) => {

            try{

                console.log(response.statusCode, body)

            }catch {

                console.warn(error)

            }finally {

                resolve()

            }
        
        })

    })

}

Ancestor.ListItem = function(Item_ID, Min, Max) {

    return new Promise(resolve => {

        Ancestor.SendToTransferList(Item_ID)

        request({

            url: 'https://utas.mob.v1.fut.ea.com/ut/game/fifa23/auctionhouse',
            method: 'POST',
            body: '{"buyNowPrice":' + Max +',"duration":3600,"itemData":{"id":'+ Item_ID +'},"startingBid":' + Min +'}',
            headers: {'X-UT-SID': Ancestor.SessionID}
    
        }, function(error, response, body){
    
            try{

                console.log((response.statusCode == 200 && 'Listed item: ' + Item_ID + ' For Max: ' + Max + ', Min: ' + Min) || response.statusCode)
    
                }catch {
    
                console.warn(error || body || 'an error occurred')
    
            } finally {

                resolve();
            }

        })

    })
}

Ancestor.PurchasePack = async function(Pack_ID) {

    request({

        url: 'https://utas.mob.v1.fut.ea.com/ut/game/fifa23/purchased/items',
        method: 'POST',
        body: '{"currency":"COINS","packId":' + Pack_ID + '}',
        headers: {'X-UT-SID': Ancestor.SessionID}

    }, async (error, response, body) => {

        try{

            let Pack = JSON.parse(body)

            let len = Pack.itemList.length

            for (let i = 0; i < len; i++) {

                let ItemList =  Pack.itemList[i]
                let item_Type = ItemList.itemType

                await new Promise(async(resolve) => {

                    if (item_Type == 'player') {

                        await Ancestor.SendToTransferList(ItemList.id)

                    }else {

                        await Ancestor.QuicksellItem(ItemList.id, 1)

                    }

                    setTimeout(()=>resolve(),1000)

                })
            }
        }catch {

            console.log(response.statusCode, body)
        }
    })
}


Ancestor.SortUnassigned = function() {

    request({

        url: 'https://utas.mob.v1.fut.ea.com/ut/game/fifa23/purchased/items',
        headers: {'X-UT-SID': Ancestor.SessionID}

    }, async (error, response, body)=> {

        try{

            let ItemList1 = JSON.parse(body)

            let len = ItemList1.itemData.length

            for (let i = 0; i < len; i++) {

                let ItemList = ItemList1.itemData[i]
                let item_Type = ItemList.itemType
                let Item_ID = ItemList.id

                await new Promise(async(resolve) => {

                    if (item_Type == 'player') {

                        await Ancestor.SendToTransferList(ItemList.id)

                    }else {

                        await Ancestor.QuicksellItem(ItemList.id, 1)

                    }

                    setTimeout(()=>resolve(),1000)

                })
            }

        }catch {

            console.log(response.statusCode, body)

        }

    })

}

Ancestor.AutolistTransfers = function() {

    request({

        url: 'https://utas.mob.v1.fut.ea.com/ut/game/fifa23/tradepile',
        headers: {'X-UT-SID': Ancestor.SessionID}

    }, async (error, response, body) => {

        try{

            let transferPile = JSON.parse(body)

            let len = transferPile.auctionInfo.length

            for (let i = 0; i < len; i++) {

                let ItemInfo = transferPile.auctionInfo[i]

                await new Promise(async(resolve) => {

                    console.log(ItemInfo.tradeState)

                    if (ItemInfo.tradeState == null || ItemInfo.tradeState == 'expired') {

                        let ItemData = ItemInfo.itemData

                        console.log(ItemInfo)

                        await Ancestor.ListItem(ItemData.id, ItemData.marketDataMinPrice, ItemData.marketDataMinPrice + 50)
                        Ancestor.GetCredits()
                    }

                    setTimeout(()=>resolve(),1000)

                    resolve()

                })
                

            }

        }catch {

        }

    })
    
}

Ancestor.GetCredits = function() {

    request({

        url: 'https://utas.mob.v1.fut.ea.com/ut/game/fifa23/usermassinfo',
        headers: {'X-UT-SID': Ancestor.SessionID}

    }, (error, response, body) => {

        let UserInfo = JSON.parse(body)

        console.log(UserInfo.userInfo.personaName + ' Has ' + UserInfo.userInfo.credits + ' credits.')

    })

}



Ancestor.AutolistTransfers()
