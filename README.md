# Pesabooks: Collaborative Crypto Investing Made Easy

## Description

Pesabooks leverages the power of decentralized technology and multi-sig wallets to provide a secure, transparent and convenient platform that allows a group of people to save and invest together in the cryptocurrency market. With Pesabooks, users can pool their funds and invest in a variety of cryptocurrencies and decentralized finance (DeFi) assets.

## About

The idea behind Pesabooks originated from a personal experience within a tontine group.

A tontine ( also known as susu, ajo, tanda...) is a traditional form of informal savings and credit system widely used in many cultures around the world. It involves a group of individuals who contribute a fixed amount of money at regular intervals into a common fund.

I wanted an accounting software adapted for tontines that provided real-time financial information accessible to all members, eliminating the need for a group secretary to maintain an Excel file on their laptop. However, [the initial approach](https://github.com/paddyfink/Old-Pesabooks) proved to be impractical, as it burdened the tontine administrator with manual transaction recording.

With this setback in mind, I realized that integrating Pesabooks with a traditional banking system would be costly, and it wouldn't address the fact that a significant portion of the third-world population remains unbanked. However, a breakthrough occurred when I delved into the world of cryptocurrencies.

Last year, fueled by an interest in crypto, I had an epiphany. I decided to revive the Pesabooks project and shift its focus from being a mere accounting software to a digital platform fueled by cryptocurrencies. The vision was simple: instead of contributing with cash, users could seamlessly contribute online using cryptocurrencies, offering heightened security, faster transactions, and low fees. Pesabooks emerged as a solution that transcends borders, enabling hassle-free money transfers and unlocking the potential for new financial instruments through DeFi.

## Installation

### Prerequisite

Before starting the installation process, there are a few tools and accounts that you will need:

1. **A Supabase account:** You will need a Supabase account to utilize the Supabase service. Supabase is an open-source platform that provides a set of tools and services for building and scaling applications with PostgreSQL databases. It offers features such as real-time data synchronization, authentication, and authorization. To create a Supabase account, visit their website (https://supabase.io/) and sign up for an account if you haven't already done so.

**note:** It is possible to run a Supabase local instance without but I haven't tried yet and cannot provide instructions at this time

2.  **Infura account:** In order to interact with the Ethereum blockchain, you will need an Infura account. Infura is a popular infrastructure provider that offers access to Ethereum's network via APIs. It allows you to read data from the blockchain, send transactions, and interact with smart contracts. To create an Infura account, go to the Infura website (https://infura.io/) and sign up for a free account.
3.  **Web3Auth account:** Web3Auth is a non-custodial auth infrastructure for Web3 apps and wallets that enables seamless user logins to both mainstream and native Web3 users. Visit the Web3auth website (https://web3auth.io/) and sign up for an account.

### Deploy Supabase project

1. Deploy database changes and functions

```bash
# Link your project
supabase link --project-ref <project-id>

# Deploy database changes
supabase db push

# Deploy Edge Functions
supabase functions deploy balances
supabase functions deploy get-access-token --no-verify-jwt
supabase functions deploy ramp-callback --no-verify-jwt
supabase functions deploy send-invitation
supabase functions deploy send-notification
```

2. Configure remote secrets

Create a `./supabase/.env` file for storing your secrets. use the .env.example file as a reference

```bash
# Push all the secrets from the .env file to our remote project
supabase secrets set --env-file ./supabase/.env
```

### Deploy the app

1. Navigate into the project directory:

```bash
cd app
```

2. Install dependencies:

```bash
yarn
```

3. Create a .env file with environment variables

You can use the .env.example file as a reference. Here's the list of all the required and optional variables:

| Env variable                    |              | Description                                                                                                |
| ------------------------------- | ------------ | ---------------------------------------------------------------------------------------------------------- |
| `REACT_APP_ENV`                 | **required** | Environment. Default `development`                                                                         |
| `REACT_APP_SUPABASE_PROJECT_ID` | **required** | [Supabase](https://supabase.com/) project id                                                               |
| `REACT_APP_SUPABASE_ANON_KEY`   | **required** | [Supabase](https://supabase.com/) anon key                                                                 |
| `REACT_APP_INFURA_KEY`          | **required** | [Infura](https://docs.infura.io/infura/networks/ethereum/how-to/secure-a-project/project-id) RPC API token |
| `REACT_APP_INCLUDE_TESTNETS`    | optional     | Include or not the tesnets (Goerli)                                                                        |
| `REACT_APP_WEB3AUTH_NETWORk`    | **required** | [Web3Auth](https://web3auth.io/) network: `testnets`, `mainnet`, or `cyan`                                 |
| `REACT_APP_WEB3AUTH_CLIENT_ID`  | **required** | [Web3Auth](https://web3auth.io/) client id                                                                 |
| `REACT_APP_RAMP_API_KEY`        | optional     | [Ramp](https://ramp.network/) host api key for Fiat onrampCollB                                            |
| `REACT_APP_SENTRY_DSN`          | optional     | [Sentry](https://sentry.io) id for tracking runtime errors `NEXT_PUBLIC_INFURA_TOKEN`                      |

4. Start the development server:

```
yarn start
```

Your app should now be running on http://localhost:3000.

## Usage

The detailed documentation for this application is available at [our documentation site](https://docs.pesabooks.com/). This includes step-by-step guides on how to use the application, tips and tricks, troubleshooting information, and more. Please refer to the documentation for the most comprehensive and up-to-date information.

Remember, the documentation is a great place to start if you're new to this application!

## Contributing

We love contributions! Please see our [Contributing guide]() for more details.

## Licence

This project is licensed under the terms of the GNU General Public License v3.0.
