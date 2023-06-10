#[test_only]
module money_market::ipx_money_market_test_2 {

//   use sui::test_scenario::{Self as test, Scenario, next_tx, ctx};
//   use sui::test_utils::{assert_eq};
//   use sui::coin::{Self, burn_for_testing as burn};
//   use sui::math;
//   use sui::clock;

//   use whirlpool::core::{Self as whirlpool, WhirlpoolAdminCap, WhirlpoolStorage, AccountStorage};
//   use whirlpool::oracle::{Self, OracleStorage, OracleAdminCap};
//   use whirlpool::interest_rate_model::{InterestRateModelStorage};
//   use ipx::ipx::{IPXStorage};
//   use sui_dollar::suid::{Self, SUID, SuiDollarStorage};
//   use library::math::{d_fmul, double_scalar};
//   use library::test_utils::{people,  mint, scenario};
//   use library::eth::{ETH};
//   use library::btc::{BTC};
//   use whirlpool::core_tests::{init_test, calculate_btc_market_rewards, calculate_suid_market_rewards};

//   const BTC_DECIMALS: u8 = 9;
//   const ETH_DECIMALS: u8 = 8;
//   const ADA_DECIMALS: u8 = 7;
//   const SUID_DECIMALS: u8 = 9;
//   const IPX_DECIMALS_FACTOR: u256 = 1000000000;
//   const BTC_DECIMALS_FACTOR: u256 = 1000000000;
//   const ETH_DECIMALS_FACTOR: u256 = 100000000;
//   const ADA_DECIMALS_FACTOR: u256 = 10000000;
//   const SUID_DECIMALS_FACTOR: u256 = 1000000000;
//   const INITIAL_RESERVE_FACTOR_MANTISSA: u64 = 200000000000000000; // 0.2e18 or 20%
//   // ATTENTION This needs to be updated when the module constant is updated.

//   fun test_deposit_(test: &mut Scenario) {
//     init_test(test);

//     let (alice, bob) = people();
//     let clock_object = clock::create_for_testing(ctx(test));

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       let coin_ipx = whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(10, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//       );

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<BTC>(&account_storage, alice);

//       assert_eq(burn(coin_ipx), 0);
//       assert_eq(collateral, 10 * math::pow(10, BTC_DECIMALS));
//       assert_eq(loan, 0);
//       assert_eq(collateral_rewards_paid, 0);
//       assert_eq(loan_rewards_paid, 0);

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage);
//     };

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       clock::increment_for_testing(&mut clock_object, 12000);

//       let coin_ipx = whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(5, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//       );

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<BTC>(&account_storage, alice);

//       let collateral_rewards_per_share = calculate_btc_market_rewards(12000, 10 * BTC_DECIMALS_FACTOR);

//       assert_eq((burn(coin_ipx) as u256), collateral_rewards_per_share * (10 * BTC_DECIMALS_FACTOR as u256) / BTC_DECIMALS_FACTOR);
//       assert_eq(collateral, 15 * math::pow(10, BTC_DECIMALS));
//       assert_eq(loan, 0);
//       assert_eq(collateral_rewards_paid, (collateral_rewards_per_share * (15 * BTC_DECIMALS_FACTOR)) / BTC_DECIMALS_FACTOR);
//       assert_eq(loan_rewards_paid, 0);

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage);
//     };

//     next_tx(test, bob);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       clock::increment_for_testing(&mut clock_object, 20000);

//       let (_, _, _, _, _, _, _, _, _, prev_collateral_rewards_per_share, _, _, _, _, _, _) = whirlpool::get_market_info<BTC>(&whirlpool_storage);

//       let coin_ipx = whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(7, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//       );

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<BTC>(&account_storage, bob);

//       let collateral_rewards_per_share = calculate_btc_market_rewards(20000, 15 * BTC_DECIMALS_FACTOR) + prev_collateral_rewards_per_share;

//       assert_eq((burn(coin_ipx) as u256), 0);
//       assert_eq((collateral as u256), 7 * BTC_DECIMALS_FACTOR);
//       assert_eq(loan, 0);
//       assert_eq(collateral_rewards_paid, (collateral_rewards_per_share * (7 * BTC_DECIMALS_FACTOR)) / BTC_DECIMALS_FACTOR);
//       assert_eq(loan_rewards_paid, 0);

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage);
//     };    

//     clock::destroy_for_testing(clock_object);
//   }

//    #[test] 
//    fun test_borrow_suid() {
//     let scenario = scenario();

//     let test = &mut scenario;
//     init_test(test);

//     let (alice, _) = people();
//     let clock_object = clock::create_for_testing(ctx(test));

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(5, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       // 60k
//       let borrow_value = ( 60000 * SUID_DECIMALS_FACTOR as u64);

//       whirlpool::enter_market<BTC>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_suid, coin_ipx) = whirlpool::borrow_suid(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         borrow_value,
//         ctx(test)
//        );

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<SUID>(&account_storage, alice);
 
//       assert_eq(burn(coin_suid), borrow_value);
//       assert_eq(burn(coin_ipx), 0); 
//       assert_eq(collateral, 0);
//       assert_eq(collateral_rewards_paid, 0);
//       assert_eq(loan, borrow_value);
//       assert_eq(loan_rewards_paid, 0);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let borrow_value = (5000 * SUID_DECIMALS_FACTOR as u64);

//       let interest_rate_per_ms = whirlpool::get_borrow_rate_per_ms<SUID>(
//         &whirlpool_storage,
//         &interest_rate_model_storage
//       );

//       let timestame_increase = 83763618;

//       clock::increment_for_testing(&mut clock_object, timestame_increase);

//       let (_, _, _, _, _, _, _, _, _, _, _, _, _, total_principal, total_borrows, _) = whirlpool::get_market_info<SUID>(&whirlpool_storage);

//       let accumulated_interest_rate = interest_rate_per_ms * timestame_increase;
//       let new_total_borrows = total_borrows + (d_fmul(total_borrows, accumulated_interest_rate) as u64);

//       // round up
//       let added_principal = (((borrow_value as u256) * (total_principal as u256)) / (new_total_borrows as u256)) + 1;

//       let (coin_suid, coin_ipx) = whirlpool::borrow_suid(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         borrow_value,
//         ctx(test)
//        );

//       // 5 epoch rewards
//       let loan_rewards_per_share = calculate_suid_market_rewards((timestame_increase as u256), 60000 * SUID_DECIMALS_FACTOR);

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<SUID>(&account_storage, alice);
//       let new_principal = 60000 * SUID_DECIMALS_FACTOR + (added_principal as u256);

//       assert_eq(burn(coin_suid), borrow_value);  
//       assert_eq((burn(coin_ipx) as u256), loan_rewards_per_share * 60000); 
//       assert_eq(collateral, 0);
//       assert_eq((loan as u256), new_principal);
//       assert_eq(collateral_rewards_paid, 0);
//       assert_eq(loan_rewards_paid, loan_rewards_per_share * new_principal / SUID_DECIMALS_FACTOR);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let borrow_value = (1000 * SUID_DECIMALS_FACTOR as u64);

//       let interest_rate_per_ms = whirlpool::get_borrow_rate_per_ms<SUID>(
//         &whirlpool_storage,
//         &interest_rate_model_storage
//       );

//       let timestame_increase = 82761673839;

//       clock::increment_for_testing(&mut clock_object, timestame_increase);

//       let (_, _, _, _, _, _, _, _, _, _, prev_loan_rewards_per_share, _, _, total_principal, total_borrows, _) = whirlpool::get_market_info<SUID>(&whirlpool_storage);

//       let accumulated_interest_rate = interest_rate_per_ms * timestame_increase;
//       let new_total_borrows = total_borrows + (d_fmul(total_borrows, accumulated_interest_rate) as u64);

//       // round up
//       let added_principal = ((((borrow_value as u256) * (total_principal as u256)) / (new_total_borrows as u256)) + 1 as u64);

//       let (_, prev_loan, _, prev_loan_rewards_paid) = whirlpool::get_account_info<SUID>(&account_storage, alice);

//       let (coin_eth, coin_ipx) = whirlpool::borrow_suid(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         borrow_value,
//         ctx(test)
//        );

//       // 5 epoch rewards
//       let loan_rewards_per_share = calculate_suid_market_rewards((timestame_increase as u256), (total_principal as u256)) + prev_loan_rewards_per_share;

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<SUID>(&account_storage, alice);
//       let new_principal = prev_loan + added_principal;

//       assert_eq(burn(coin_eth), borrow_value);  
//       assert_eq((burn(coin_ipx) as u256), (loan_rewards_per_share * (prev_loan as u256) / SUID_DECIMALS_FACTOR) - prev_loan_rewards_paid); 
//       assert_eq(collateral, 0);
//       assert_eq(loan, new_principal);
//       assert_eq(collateral_rewards_paid, 0);
//       assert_eq(loan_rewards_paid, loan_rewards_per_share * (new_principal as u256) / SUID_DECIMALS_FACTOR);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   fun test_repay_suid() {
//     let scenario = scenario();

//     let test = &mut scenario;

//      init_test(test);
//     let clock_object = clock::create_for_testing(ctx(test));

//     let (alice, _) = people();

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);

//       // Need to increase the supply to prevent bugs due the way the test contract is written
//       burn(suid::mint_for_testing(&mut suid_storage, (5000 * SUID_DECIMALS_FACTOR as u64), ctx(test)));

//       burn(whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(10, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let borrow_value = (10000 * SUID_DECIMALS_FACTOR as u64);

//       whirlpool::enter_market<BTC>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_eth, coin_ipx) = whirlpool::borrow_suid(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         borrow_value,
//         ctx(test)
//        );

//       burn(coin_eth);
//       burn(coin_ipx);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);

//       let timestame_increase = 3837618193;

//       clock::increment_for_testing(&mut clock_object, timestame_increase);

//       let coin_ipx = whirlpool::repay_suid(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &clock_object,
//         mint<SUID>(6000, SUID_DECIMALS, ctx(test)),
//         (5000 * SUID_DECIMALS_FACTOR as u64),
//         ctx(test)
//       );

//       let loan_rewards_per_share = calculate_suid_market_rewards((timestame_increase as u256), 10000 * SUID_DECIMALS_FACTOR);
//       let (_, loan, _, loan_rewards_paid) = whirlpool::get_account_info<SUID>(&account_storage, alice);

//       assert_eq((burn(coin_ipx) as u256), loan_rewards_per_share * 10000);
//       assert_eq(loan, (5000 * SUID_DECIMALS_FACTOR as u64));
//       assert_eq(loan_rewards_paid, loan_rewards_per_share * 5000);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);

//       let timestame_increase = 33234532393;

//       clock::increment_for_testing(&mut clock_object, timestame_increase);

//       let (_, _, _, _, _, _, _, _, _, _, prev_loan_rewards_per_share, _, _, _, _, _) = whirlpool::get_market_info<SUID>(&whirlpool_storage);

//       let (_, prev_loan, _, prev_loan_rewards_paid) = whirlpool::get_account_info<SUID>(&account_storage, alice);

//       let coin_ipx = whirlpool::repay_suid(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &clock_object,
//         mint<SUID>(100000, SUID_DECIMALS, ctx(test)),
//         (5000 * SUID_DECIMALS_FACTOR as u64),
//         ctx(test)
//       );

//       let loan_rewards_per_share = calculate_suid_market_rewards((timestame_increase as u256), 5000 * SUID_DECIMALS_FACTOR) + prev_loan_rewards_per_share;
//       let (_, loan, _, loan_rewards_paid) = whirlpool::get_account_info<SUID>(&account_storage, alice);

//       assert_eq((burn(coin_ipx) as u256), (loan_rewards_per_share * (prev_loan as u256) / SUID_DECIMALS_FACTOR) - prev_loan_rewards_paid);
//       assert_eq(loan, 0);
//       assert_eq(loan_rewards_paid, 0);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_MARKET_IS_PAUSED)]
//   fun test_fail_repay_suid_paused() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);
//     let clock_object = clock::create_for_testing(ctx(test));

//     let (alice, _) = people();

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);

//       // Need to increase the supply to prevent bugs due the way the test contract is written
//       burn(suid::mint_for_testing(&mut suid_storage, (5000 * SUID_DECIMALS_FACTOR as u64), ctx(test)));

//       burn(whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(10, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let borrow_value = (10000 * SUID_DECIMALS_FACTOR as u64);

//       whirlpool::enter_market<BTC>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_eth, coin_ipx) = whirlpool::borrow_suid(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         borrow_value,
//         ctx(test)
//        );

//       burn(coin_eth);
//       burn(coin_ipx);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let whirlpool_admin_cap = test::take_from_address<WhirlpoolAdminCap>(test, alice);

//       let timestame_increase = 33234532393;

//       clock::increment_for_testing(&mut clock_object, timestame_increase);

//       whirlpool::pause_market<SUID>(&whirlpool_admin_cap, &mut whirlpool_storage);

//       let coin_ipx = whirlpool::repay_suid(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &clock_object,
//         mint<SUID>(6000, SUID_DECIMALS, ctx(test)),
//         (5000 * SUID_DECIMALS_FACTOR as u64),
//         ctx(test)
//       );

//       let loan_rewards_per_share = calculate_suid_market_rewards(5, 10000 * SUID_DECIMALS_FACTOR);
//       let (_, loan, _, loan_rewards_paid) = whirlpool::get_account_info<SUID>(&account_storage, alice);

//       assert_eq((burn(coin_ipx) as u256), loan_rewards_per_share * 10000);
//       assert_eq(loan, (5000 * SUID_DECIMALS_FACTOR as u64));
//       assert_eq(loan_rewards_paid, loan_rewards_per_share * 5000);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_to_address(alice, whirlpool_admin_cap);
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   fun test_liquidate() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);
//     let clock_object = clock::create_for_testing(ctx(test));

//     let (alice, bob) = people();

//     // Deposit 200k USD can borrow up to 140k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(10, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     next_tx(test, bob);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<ETH>(150, ETH_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     // Borrow 127.4k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let borrow_value = (91 * ETH_DECIMALS_FACTOR as u64);

//       whirlpool::enter_market<BTC>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_eth, coin_ipx) = whirlpool::borrow<ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         borrow_value,
//         ctx(test)
//        );

//        burn(coin_eth);
//        burn(coin_ipx);

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//      next_tx(test, alice);
//      {
//       let oracle_admin_cap = test::take_from_address<OracleAdminCap>(test, alice);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       // BTC
//       oracle::set_price<BTC>(
//         &oracle_admin_cap,
//         &mut oracle_storage,
//         180000000000, // 18k
//         7,
//         ctx(test)
//       );
     
//      test::return_to_address(alice, oracle_admin_cap);
//      test::return_shared(oracle_storage);
//      };

//      next_tx(test, bob);
//      {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let timestame_increase = 38452;

//       clock::increment_for_testing(&mut clock_object, timestame_increase);

//       let interest_rate_per_ms = whirlpool::get_borrow_rate_per_ms<ETH>(
//         &whirlpool_storage,
//         &interest_rate_model_storage
//       );

//       let (_, _, _, _, _, _, _, _, _, _, _, _, _, _, total_borrows, _) = whirlpool::get_market_info<ETH>(&whirlpool_storage);

//       let accumulated_interest_rate = interest_rate_per_ms * timestame_increase;
//       let new_total_borrows = total_borrows + (d_fmul(total_borrows, accumulated_interest_rate) as u64);

//       whirlpool::liquidate<BTC, ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<ETH>(new_total_borrows, 0, ctx(test)),
//         alice,
//         ctx(test)
//       );

//       let (_, accrued_timestamp, _, _, _, _, _, _, _, btc_accrued_collateral_rewards_per_share, _, _, _, _, _, _) = whirlpool::get_market_info<BTC>(&whirlpool_storage);
//       assert_eq(accrued_timestamp, timestame_increase);

//       let (_, accrued_timestamp, _, _, balance_value, _, _, _, _, _, _, _, _, total_principal, total_borrows, _) = whirlpool::get_market_info<ETH>(&whirlpool_storage);
//       assert_eq(accrued_timestamp, timestame_increase);
//       assert_eq(total_borrows, 0);
//       assert_eq(total_principal, 0);
//       assert_eq(balance_value, ((59 * ETH_DECIMALS_FACTOR) as u64) + new_total_borrows);

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<ETH>(&account_storage, alice);
//       assert_eq(collateral, 0);
//       assert_eq(loan, 0);
//       assert_eq(collateral_rewards_paid, 0);
//       assert_eq(loan_rewards_paid, 0);

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<BTC>(&account_storage, alice);

//       let scalar = double_scalar();

//       let loan_in_usd = ((new_total_borrows as u256) * 1400000000000000000000) / scalar; // ETH decimals

//       let loan_in_btc = (((loan_in_usd * scalar) / 18000000000000000000000) * BTC_DECIMALS_FACTOR) / ETH_DECIMALS_FACTOR;

//       // 0.07%
//       let loan_penalty = (loan_in_btc * 50000000000000000) / scalar;

//       let loan_in_btc = loan_in_btc + loan_penalty;


//       assert_eq((collateral as u256), 10 * BTC_DECIMALS_FACTOR - loan_in_btc);
//       assert_eq(loan, 0);
//       assert_eq(collateral_rewards_paid, ((collateral as u256) * btc_accrued_collateral_rewards_per_share) / BTC_DECIMALS_FACTOR);
//       assert_eq(loan_rewards_paid, 0);

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<BTC>(&account_storage, bob);
//       assert_eq(loan, 0);
//       assert_eq(loan_rewards_paid, 0);
//       assert_eq((collateral as u256), loan_in_btc - (loan_penalty * 200000000000000000) / scalar);
//       assert_eq(collateral_rewards_paid, ((collateral as u256) * btc_accrued_collateral_rewards_per_share) / BTC_DECIMALS_FACTOR);

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<ETH>(&account_storage, bob);
//       assert_eq(loan, 0);
//       assert_eq(loan_rewards_paid, 0);
//       assert_eq(collateral, ((150 * ETH_DECIMALS_FACTOR) as u64));
//       assert_eq(collateral_rewards_paid, 0);

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//      };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   fun test_liquidate_rewards() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);
//     let clock_object = clock::create_for_testing(ctx(test));

//     let (alice, bob) = people();

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(10, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     next_tx(test, bob);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<ETH>(500, ETH_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     // Borrow 127.4k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let borrow_value = (91 * ETH_DECIMALS_FACTOR as u64);

//       whirlpool::enter_market<BTC>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_eth, coin_ipx) = whirlpool::borrow<ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         borrow_value,
//         ctx(test)
//        );

//        burn(coin_eth);
//        burn(coin_ipx);

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };    

//     next_tx(test, bob);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let borrow_value = (10 * BTC_DECIMALS_FACTOR as u64);

//       whirlpool::enter_market<ETH>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_btc, coin_ipx) = whirlpool::borrow<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         borrow_value,
//         ctx(test)
//        );

//        burn(coin_btc);
//        burn(coin_ipx);

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//      next_tx(test, alice);
//      {
//       let oracle_admin_cap = test::take_from_address<OracleAdminCap>(test, alice);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       // BTC
//       oracle::set_price<BTC>(
//         &oracle_admin_cap,
//         &mut oracle_storage,
//         180000000000, // 18k
//         7,
//         ctx(test)
//       );
     
//      test::return_to_address(alice, oracle_admin_cap);
//      test::return_shared(oracle_storage);
//      };    
    
//     next_tx(test, bob);
//    {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let timestame_increase = 98452;

//       clock::increment_for_testing(&mut clock_object, timestame_increase);

//       let interest_rate_per_ms = whirlpool::get_borrow_rate_per_ms<ETH>(
//         &whirlpool_storage,
//         &interest_rate_model_storage
//       );

//        let btc_interest_rate_per_ms = whirlpool::get_borrow_rate_per_ms<BTC>(
//          &whirlpool_storage,
//         &interest_rate_model_storage
//       );

//       let (_, _, _, _, _, _, _, _, _, _, _, _, _, _, total_borrows, _) = whirlpool::get_market_info<ETH>(&whirlpool_storage);
//       let (_, _, _, _, _, _, _, _, _, _, _, _, _, _, btc_total_borrows, _) = whirlpool::get_market_info<BTC>(&whirlpool_storage);

//       let accumulated_interest_rate = interest_rate_per_ms * timestame_increase;
//       let new_total_borrows = total_borrows + (d_fmul(total_borrows, accumulated_interest_rate) as u64);

//       let btc_accumulated_interest_rate = btc_interest_rate_per_ms * timestame_increase;
//       let btc_paid_amount = (d_fmul(btc_total_borrows, btc_accumulated_interest_rate) as u64);
//       let btc_reserve_amount = d_fmul(btc_paid_amount, INITIAL_RESERVE_FACTOR_MANTISSA);
      

//       whirlpool::liquidate<BTC, ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<ETH>(new_total_borrows, 0, ctx(test)),
//         alice,
//         ctx(test)
//       );

//       let (_, _, _, _, _, _, _, _, _, btc_accrued_collateral_rewards_per_share, _, _, elastic_collateral, _, _, _) = whirlpool::get_market_info<BTC>(&whirlpool_storage);

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<BTC>(&account_storage, alice);

//       assert_eq((elastic_collateral as u256), (10 * BTC_DECIMALS_FACTOR) + ((btc_paid_amount as u256) - btc_reserve_amount));
//       assert_eq(loan, 0);
//       assert_eq(collateral_rewards_paid, ((collateral as u256) * btc_accrued_collateral_rewards_per_share) / BTC_DECIMALS_FACTOR);
//       assert_eq(loan_rewards_paid, 0);

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//    };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_LIQUIDATOR_IS_BORROWER)]
//   fun test_liquidate_error_liquidator_is_borrower() {
//      let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);

//     let (alice, _) = people();
//     let clock_object = clock::create_for_testing(ctx(test));

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::liquidate<BTC, ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<ETH>(1, 0, ctx(test)),
//         alice,
//         ctx(test)
//       );

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_SUID_OPERATION_NOT_ALLOWED)]
//   fun test_liquidate_error_dinero_collateral() {
//      let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);

//     let (alice, bob) = people();
//     let clock_object = clock::create_for_testing(ctx(test));

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::liquidate<SUID, ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<ETH>(1, 0, ctx(test)),
//         bob,
//         ctx(test)
//       );

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_SUID_OPERATION_NOT_ALLOWED)]
//   fun test_liquidate_error_dinero_loan() {
//      let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);
//     let clock_object = clock::create_for_testing(ctx(test));

//     let (alice, bob) = people();

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::liquidate<ETH, SUID>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<SUID>(1, 0, ctx(test)),
//         bob,
//         ctx(test)
//       );

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_ACCOUNT_COLLATERAL_DOES_EXIST)]
//   fun test_liquidate_error_borrow_no_collateral_account() {
//      let scenario = scenario();

//     let test = &mut scenario;
//     let clock_object = clock::create_for_testing(ctx(test));

//     init_test(test);

//     let (alice, bob) = people();

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::liquidate<ETH, BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<BTC>(1, 0, ctx(test)),
//         bob,
//         ctx(test)
//       );

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_ACCOUNT_LOAN_DOES_EXIST)]
//   fun test_liquidate_error_borrow_no_loan_account() {
//      let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);
//     let clock_object = clock::create_for_testing(ctx(test));

//     let (alice, bob) = people();

//     next_tx(test, bob);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<ETH>(5, ETH_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::liquidate<ETH, BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<BTC>(1, 0, ctx(test)),
//         bob,
//         ctx(test)
//       );

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_USER_IS_SOLVENT)]
//   fun test_liquidate_error_borrower_is_solvent() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);
//     let clock_object = clock::create_for_testing(ctx(test));

//     let (alice, bob) = people();

//     // Deposit 200k USD can borrow up to 140k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(10, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     next_tx(test, bob);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<ETH>(150, ETH_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     // Borrow 127.4k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let borrow_value = (91 * ETH_DECIMALS_FACTOR as u64);

//       whirlpool::enter_market<BTC>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_eth, coin_ipx) = whirlpool::borrow<ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         borrow_value,
//         ctx(test)
//        );

//        burn(coin_eth);
//        burn(coin_ipx);

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//      next_tx(test, bob);
//      {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::liquidate<BTC, ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<ETH>(1, 0, ctx(test)),
//         alice,
//         ctx(test)
//       );

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//      };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

// #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_ZERO_LIQUIDATION_AMOUNT)]
//   fun test_liquidate_error_zero_amount() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);

//     let (alice, bob) = people();
//     let clock_object = clock::create_for_testing(ctx(test));

//     // Deposit 200k USD can borrow up to 140k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(10, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     next_tx(test, bob);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<ETH>(150, ETH_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     // Borrow 127.4k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let borrow_value = (91 * ETH_DECIMALS_FACTOR as u64);

//       whirlpool::enter_market<BTC>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_eth, coin_ipx) = whirlpool::borrow<ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         borrow_value,
//         ctx(test)
//        );

//        burn(coin_eth);
//        burn(coin_ipx);

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     next_tx(test, alice);
//      {
//       let oracle_admin_cap = test::take_from_address<OracleAdminCap>(test, alice);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       // BTC
//       oracle::set_price<BTC>(
//         &oracle_admin_cap,
//         &mut oracle_storage,
//         180000000000, // 18k
//         7,
//         ctx(test)
//       );
     
//      test::return_to_address(alice, oracle_admin_cap);
//      test::return_shared(oracle_storage);
//      };   

//      next_tx(test, bob);
//      {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::liquidate<BTC, ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         coin::zero<ETH>(ctx(test)),
//         alice,
//         ctx(test)
//       );

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//      };

//     clock::destroy_for_testing(clock_object); 
//     test::end(scenario);
//   }

//   #[test]
//   fun test_liquidate_suid() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);
//     let clock_object = clock::create_for_testing(ctx(test));

//     let (alice, bob) = people();

//     // Deposit 200k USD can borrow up to 140k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(10, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//      // Borrow 127.4k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::enter_market<BTC>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_suid, coin_ipx) = whirlpool::borrow_suid(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         (126000 * SUID_DECIMALS_FACTOR as u64),
//         ctx(test)
//        );

//        burn(coin_suid);
//        burn(coin_ipx);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//      next_tx(test, alice);
//      {
//       let oracle_admin_cap = test::take_from_address<OracleAdminCap>(test, alice);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       // BTC
//       oracle::set_price<BTC>(
//         &oracle_admin_cap,
//         &mut oracle_storage,
//         180000000000, // 18k
//         7,
//         ctx(test)
//       );
     
//      test::return_to_address(alice, oracle_admin_cap);
//      test::return_shared(oracle_storage);
//      };

//      next_tx(test, bob);
//      {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let timestame_increase = 38452;

//       // Need to increase the supply to prevent bugs due the way the test contract is written
//       burn(suid::mint_for_testing(&mut suid_storage, (1000000000 * SUID_DECIMALS_FACTOR as u64), ctx(test)));

//       clock::increment_for_testing(&mut clock_object, timestame_increase);

//       let interest_rate_per_ms = whirlpool::get_borrow_rate_per_ms<SUID>(
//         &whirlpool_storage,
//         &interest_rate_model_storage
//       );

//       let (_, _, _, _, _, _, _, _, _, _, _, _, _, _, total_borrows, _) = whirlpool::get_market_info<SUID>(&whirlpool_storage);

//       let accumulated_interest_rate = interest_rate_per_ms * timestame_increase;
//       let new_total_borrows = total_borrows + (d_fmul(total_borrows, accumulated_interest_rate) as u64);

//       whirlpool::liquidate_suid<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<SUID>(new_total_borrows, 0, ctx(test)),
//         alice,
//         ctx(test)
//       );

//       let (_, accrued_timestamp, _, _, _, _, _, _, _, btc_accrued_collateral_rewards_per_share, _, _, _, _, _, _) = whirlpool::get_market_info<BTC>(&whirlpool_storage);
//       assert_eq(accrued_timestamp, timestame_increase);

//       let (_, accrued_timestamp, _, _, balance_value, _, _, _, _, _, _, _, _, total_principal, total_borrows, _) = whirlpool::get_market_info<SUID>(&whirlpool_storage);
//       assert_eq(accrued_timestamp, timestame_increase);
//       assert_eq(total_borrows, 0);
//       assert_eq(total_principal, 0);
//       assert_eq(balance_value, 0);

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<SUID>(&account_storage, alice);
//       assert_eq(collateral, 0);
//       assert_eq(loan, 0);
//       assert_eq(collateral_rewards_paid, 0);
//       assert_eq(loan_rewards_paid, 0);

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<BTC>(&account_storage, alice);

//       let scalar = double_scalar();

//       let loan_in_usd = ((new_total_borrows as u256) * scalar) / scalar; // ETH decimals

//       let loan_in_btc = (((loan_in_usd * scalar) / 18000000000000000000000) * BTC_DECIMALS_FACTOR) / SUID_DECIMALS_FACTOR;

//       // 0.07%
//       let loan_penalty = (loan_in_btc * 50000000000000000) / scalar;

//       let loan_in_btc = loan_in_btc + loan_penalty;


//       assert_eq((collateral as u256), 10 * BTC_DECIMALS_FACTOR - loan_in_btc);
//       assert_eq(loan, 0);
//       assert_eq(collateral_rewards_paid, ((collateral as u256) * btc_accrued_collateral_rewards_per_share) / BTC_DECIMALS_FACTOR);
//       assert_eq(loan_rewards_paid, 0);

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<BTC>(&account_storage, bob);
//       assert_eq(loan, 0);
//       assert_eq(loan_rewards_paid, 0);
//       assert_eq((collateral as u256), loan_in_btc - (loan_penalty * 200000000000000000) / scalar);
//       assert_eq(collateral_rewards_paid, ((collateral as u256) * btc_accrued_collateral_rewards_per_share) / BTC_DECIMALS_FACTOR);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//      };     

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   fun test_liquidate_suid_rewards() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);
//     let clock_object = clock::create_for_testing(ctx(test));

//     let (alice, bob) = people();

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(10, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage);       
//     };

//     next_tx(test, bob);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<ETH>(500, ETH_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//      // Borrow 127.4k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::enter_market<BTC>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_suid, coin_ipx) = whirlpool::borrow_suid(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         (127000 * SUID_DECIMALS_FACTOR as u64), // BTC earned some rewwards - need to borrow a bit more
//         ctx(test)
//        );

//        burn(coin_suid);
//        burn(coin_ipx);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     next_tx(test, bob);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let borrow_value = (10 * BTC_DECIMALS_FACTOR as u64);

//       whirlpool::enter_market<ETH>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_btc, coin_ipx) = whirlpool::borrow<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &oracle_storage,
//         &clock_object,
//         borrow_value,
//         ctx(test)
//        );

//        burn(coin_btc);
//        burn(coin_ipx);

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//      next_tx(test, alice);
//      {
//       let oracle_admin_cap = test::take_from_address<OracleAdminCap>(test, alice);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       // BTC
//       oracle::set_price<BTC>(
//         &oracle_admin_cap,
//         &mut oracle_storage,
//         180000000000, // 18k
//         7,
//         ctx(test)
//       );
     
//      test::return_to_address(alice, oracle_admin_cap);
//      test::return_shared(oracle_storage);
//      };    

//     next_tx(test, bob);
//    {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let timestame_increase = 98452;

//       // Need to increase the supply to prevent bugs due the way the test contract is written
//       burn(suid::mint_for_testing(&mut suid_storage, (1000000000 * SUID_DECIMALS_FACTOR as u64), ctx(test)));

//       clock::increment_for_testing(&mut clock_object, timestame_increase);

//       let interest_rate_per_ms = whirlpool::get_borrow_rate_per_ms<SUID>(
//         &whirlpool_storage,
//         &interest_rate_model_storage
//       );

//        let btc_interest_rate_per_ms = whirlpool::get_borrow_rate_per_ms<BTC>(
//          &whirlpool_storage,
//         &interest_rate_model_storage
//       );

//       let (_, _, _, _, _, _, _, _, _, _, _, _, _, _, total_borrows, _) = whirlpool::get_market_info<SUID>(&whirlpool_storage);
//       let (_, _, _, _, _, _, _, _, _, _, _, _, _, _, btc_total_borrows, _) = whirlpool::get_market_info<BTC>(&whirlpool_storage);

//       let accumulated_interest_rate = interest_rate_per_ms * timestame_increase;
//       let new_total_borrows = total_borrows + (d_fmul(total_borrows, accumulated_interest_rate) as u64);

//       let btc_accumulated_interest_rate = btc_interest_rate_per_ms * timestame_increase;
//       let btc_paid_amount = (d_fmul(btc_total_borrows, btc_accumulated_interest_rate) as u64);
//       let btc_reserve_amount = d_fmul(btc_paid_amount, INITIAL_RESERVE_FACTOR_MANTISSA);
      

//       whirlpool::liquidate_suid<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<SUID>(new_total_borrows, 0, ctx(test)),
//         alice,
//         ctx(test)
//       );

//       let (_, _, _, _, _, _, _, _, _, btc_accrued_collateral_rewards_per_share, _, _, elastic_collateral, _, _, _) = whirlpool::get_market_info<BTC>(&whirlpool_storage);

//       let (collateral, loan, collateral_rewards_paid, loan_rewards_paid) = whirlpool::get_account_info<BTC>(&account_storage, alice);

//       assert_eq((elastic_collateral as u256), (10 * BTC_DECIMALS_FACTOR) + ((btc_paid_amount as u256) - btc_reserve_amount));
//       assert_eq(loan, 0);
//       assert_eq(collateral_rewards_paid, ((collateral as u256) * btc_accrued_collateral_rewards_per_share) / BTC_DECIMALS_FACTOR);
//       assert_eq(loan_rewards_paid, 0);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_LIQUIDATOR_IS_BORROWER)]
//   fun test_liquidate_suid_error_liquidator_is_borrower() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);

//     let (alice, _) = people();
//     let clock_object = clock::create_for_testing(ctx(test));

//     next_tx(test, alice);  
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::liquidate_suid<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<SUID>(1, 0, ctx(test)),
//         alice,
//         ctx(test)
//       );

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage);       
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario); 
//   }

//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_SUID_OPERATION_NOT_ALLOWED)]
//   fun test_liquidate_suid_error_suid_collateral() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);

//     let (alice, bob) = people();
//     let clock_object = clock::create_for_testing(ctx(test));

//     next_tx(test, alice);  
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::liquidate_suid<SUID>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<SUID>(1, 0, ctx(test)),
//         bob,
//         ctx(test)
//       );

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage);       
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario); 
//   }



//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_ACCOUNT_COLLATERAL_DOES_EXIST)]
//   fun test_liquidate_suid_error_no_collateral_account() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);

//     let (alice, bob) = people();
//     let clock_object = clock::create_for_testing(ctx(test));

//     next_tx(test, alice);  
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::liquidate_suid<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<SUID>(1, 0, ctx(test)),
//         bob,
//         ctx(test)
//       );

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage);       
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario); 
//   }

//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_ACCOUNT_LOAN_DOES_EXIST)]
//   fun test_liquidate_suid_error_no_borrow_account() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);

//     let (alice, bob) = people();
//     let clock_object = clock::create_for_testing(ctx(test));

//     // Deposit 200k USD can borrow up to 140k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(10, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//     next_tx(test, bob);  
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::liquidate_suid<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<SUID>(1, 0, ctx(test)),
//         alice,
//         ctx(test)
//       );

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage);       
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario); 
//   }

//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_USER_IS_SOLVENT)]
//   fun test_liquidate_suid_error_user_is_solvent() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);

//     let (alice, bob) = people();
//     let clock_object = clock::create_for_testing(ctx(test));

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(10, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage);       
//     };

//     next_tx(test, bob);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<ETH>(500, ETH_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//      // Borrow 127.4k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::enter_market<BTC>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_suid, coin_ipx) = whirlpool::borrow_suid(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         (126000 * SUID_DECIMALS_FACTOR as u64), // BTC earned some rewwards - need to borrow a bit more
//         ctx(test)
//        );

//        burn(coin_suid);
//        burn(coin_ipx);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     next_tx(test, bob);
//    {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let timestame_increase = 98452;

//       clock::increment_for_testing(&mut clock_object, timestame_increase);
      
//       whirlpool::liquidate_suid<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         mint<SUID>(1, 0, ctx(test)),
//         alice,
//         ctx(test)
//       );

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }

//   #[test]
//   #[expected_failure(abort_code = whirlpool::core::ERROR_ZERO_LIQUIDATION_AMOUNT)]
//   fun test_liquidate_suid_error_zero_amount() {
//     let scenario = scenario();

//     let test = &mut scenario;

//     init_test(test);

//     let (alice, bob) = people();
//     let clock_object = clock::create_for_testing(ctx(test));

//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<BTC>(10, BTC_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage);       
//     };

//     next_tx(test, bob);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);

//       burn(whirlpool::deposit<ETH>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &clock_object,
//         mint<ETH>(500, ETH_DECIMALS, ctx(test)),
//         ctx(test)
//        ));

//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//     };

//      // Borrow 127.4k USD
//     next_tx(test, alice);
//     {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       whirlpool::enter_market<BTC>(&whirlpool_storage, &mut account_storage, ctx(test));

//       let (coin_suid, coin_ipx) = whirlpool::borrow_suid(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         (126000 * SUID_DECIMALS_FACTOR as u64), // BTC earned some rewwards - need to borrow a bit more
//         ctx(test)
//        );

//        burn(coin_suid);
//        burn(coin_ipx);

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//      next_tx(test, alice);
//      {
//       let oracle_admin_cap = test::take_from_address<OracleAdminCap>(test, alice);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       // BTC
//       oracle::set_price<BTC>(
//         &oracle_admin_cap,
//         &mut oracle_storage,
//         180000000000, // 18k
//         7,
//         ctx(test)
//       );
     
//      test::return_to_address(alice, oracle_admin_cap);
//      test::return_shared(oracle_storage);
//      };    

//     next_tx(test, bob);
//    {
//       let whirlpool_storage = test::take_shared<WhirlpoolStorage>(test);
//       let account_storage = test::take_shared<AccountStorage>(test);
//       let interest_rate_model_storage = test::take_shared<InterestRateModelStorage>(test);
//       let ipx_storage = test::take_shared<IPXStorage>(test);
//       let suid_storage = test::take_shared<SuiDollarStorage>(test);
//       let oracle_storage = test::take_shared<OracleStorage>(test);

//       let timestame_increase = 98452;

//       clock::increment_for_testing(&mut clock_object, timestame_increase);
      
//       whirlpool::liquidate_suid<BTC>(
//         &mut whirlpool_storage,
//         &mut account_storage,
//         &interest_rate_model_storage,
//         &mut ipx_storage,
//         &mut suid_storage,
//         &oracle_storage,
//         &clock_object,
//         coin::zero<SUID>(ctx(test)),
//         alice,
//         ctx(test)
//       );

//       test::return_shared(suid_storage);
//       test::return_shared(ipx_storage);
//       test::return_shared(interest_rate_model_storage);
//       test::return_shared(account_storage);
//       test::return_shared(whirlpool_storage); 
//       test::return_shared(oracle_storage); 
//     };

//     clock::destroy_for_testing(clock_object);
//     test::end(scenario);
//   }
}