# API Inventory for Key Mobile Flows

Этот файл фиксирует эндпоинты, которые вызывают основные экраны приложения. Для каждого указаны HTTP-метод, путь и ожидаемая модель (по `AppMethods`/`AppStructs`). Это нужно, чтобы мок-сервер и реальный бэкенд возвращали корректные JSON и не вызывали `decodeError`.

## 1. Регистрация / Аутентификация
- `POST registration` → `Auth.Register.Result` (`{ key }`)
- `POST registration/confirm` → `Auth.Confirm.Result` (`{ walletExist, key }`)
- `POST registration/pin` → `Auth.SetPin.Result` (`{ code, expire, token }`)
- `POST registration/resend` → `Auth.Resend.Result` (`{ key }`)
- `POST sign` → `Auth.SignIn.Result` (`{ smsSign }`)
- `POST sign/confirm` → `Auth.SignConfirm.Result` (`{ message }`)
- `POST auth/refresh` → `Auth.RefreshToken.Result` (`{ token }`)
- `POST auth/deviceUpdate` → `Auth.DeviceUpdate.Result` (`{ message? }`)

## 2. Главный экран / Домашние данные
- `GET accounts/accounts` → `[AppStructs.Account]` (кошелек и бонусы)
- `GET clients/client` → `AppStructs.ClientInfo`
- `GET clients/client/identification` → `AppMethods.Client.IdentifyGet.IdentifyResult`
- `GET clients/limits` → `[AppStructs.ClientInfo.Limit]`
- `GET cards/card` → `[AppStructs.CreditDebitCard]`
- `GET cards/card/balance/{id}` → `AppStructs.CreditDebitCard`
- `GET services/services` → `Payments.GetServices.ServicesResult` (`{ groups: [PaymentGroup], transfers: [ServiceItem] }`)
- `GET services/rates` → `[AppStructs.CurrencyRate]`
- `GET banners/cash_back?limit=&offset=` → `[AppStructs.Showcase]`
- `GET simple/banners/stories` → `[AppStructs.Stories]`
- `GET notify/notifications?limit=&offset=` → `[AppStructs.NotificationNews]`
- `GET simple/banners/banners` → `[AppStructs.Banner]`
- `GET clients/favorites` → `[AppStructs.Favourite]`

## 3. Карты
- `GET cards/card` → `[AppStructs.CreditDebitCard]`
- `POST cards/card` → `Cards.AddUserCard.AddCardResult` (`{ id, isVerify }`)
- `POST cards/card/verify` → пустой успех
- `PUT cards/card` → пустой успех (обновление PINOnPay/block/color/internetPay)
- `PUT cards/card/pin` → пустой успех
- `DELETE cards/card/{id}` → пустой успех
- `GET cards/card/categories` (если используется) → `CardTypes`
- `POST cards/card/order` / `orders` / `payment` → структуры `Card.OrderBankCard.*`

## 4. Платежи и переводы
- `GET services/services` (см. выше)
- `POST services/service/check` → `Payment.Check.Result`
- `POST services/service/pay` → `Payment.Pay.Result`
- `POST services/transaction/verify` → `Payments.TransactionVerify.VerifyResult`
- `POST services/transaction/send` → `Payments.TransactionSend.TransferSendResult`
- `POST simple/services/transfer/data` → `TransferSendResult`
- `POST simple/services/transfer/confirm` → `TransferConfirmResult`
- `GET services/favourites` + `POST services/favourites`/`DELETE` → `[AppStructs.Favourite]`

## 5. История
- `GET history/history?limit=&offset=` → `[AppStructs.HistoryItem]`
- `GET accounts/history/{tranId}` → `AppStructs.HistoryItem`
- `GET accounts/history/filters` → `HistoryFilters`

## 6. QR
- `POST qr/check` → `PaymentsService.qrCheck` (см. `AppMethods.QR.Check.Result`)
- `POST qr/pay` → подтверждение QR оплаты

## 7. Профиль и настройки
- `PUT clients/client` → обновление данных
- `PUT clients/client/settings` → `Empty`
- `POST clients/client/avatar` → сохранение аватара
- `GET clients/docs` → `AppMethods.App.GetDocs.Result`
- `GET clients/client/logout` → `Logout`

## 8. Идентификация
- `GET clients/client/identification` / `POST clients/client/identification`
- `GET clients/limits` (см. пункт 2)
- `POST clients/client/identification/upload` (если присутствует) → `UploadResult`

## 9. Уведомления / Push
- `GET notify/notifications` → `[NotificationNews]`
- `POST notify/notifications/{id}/read` → `Empty`

---
Следующие шаги: для каждого из перечисленных эндпоинтов проверить вызовы в приложении (через логи) и добавить соответствующий ответ в мок-сервер. После покрытия — прогнать флоу и вычистить `decodeError`.
