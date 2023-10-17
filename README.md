# cosmicplace
an extremely large, land-value-taxed collaborative canvas

currently very very early alpha

You've likely heard of r/Place, a few-day experiment Reddit ran a few times, which was a shared canvas anyone can paint on. It's anarchy, up to the cooldown timer. What emerged on the canvas from these constraints? Lots of conflict, lots of engagement, and a lot of detail and art in a relatively small canvas in each round it was run.
It's not the first time something like it has been tried, but it's one of the most notable. Our World Of Pixels, which came before, is similar in its mechanics in that (most) of the canvas is anarchic, although notably, the canvas is huge (2^25x2^25) and some territory can be protected by the admins. Like r/Place, it's home to a lot of art and personal expression. Interestingly, some territory is *still* much more "valuable" (contested) than others, despite the vast size, due to location.
Years earlier, the Million Dollar Homepage tried a different approach, selling and auctioning off pieces of a 1000x1000 canvas, which were quickly scooped up, primarily by advertisers, but by some individuals just wanting to leave their marks as well.

Alongside these, several other similar projects have been tried across web2 and even a handful in web3.
Between all of them, there's a lot of parallels between pixel terrain, real-world land, and land in more complicated virtual worlds.

Despite being such simple "worlds", there's a lot of contention and warfare in the anarchic worlds (r/place having millions of hours of user interaction over a few days of running, for example) and the Million Dollar Homepage impressively earned a 21 year old $1M in 2005 and all it took was $50 to set up a website and selling and auctioning off 10x10 blocks on eBay.
Also analogous to real-world land, certain locations are more valuable, either intrinsically or because of what else is around them: 
on r/Place, there's heatmaps to show which areas were the most contested, this is easiest to see for the 2015 instance because the canvas size didn't change: the corners and center of the map are the most contested.

On canvases with arguably no scarcity at all like Our World of Pixels and others, there's the most activity around the spawnpoint at 0,0, and along coordinate axes and major notable coordinate points (powers of 10, funny numbers like 420, 69, 666), sometimes circular or square rings at certain distances around the origin, and a tiny bit at the world border's corners, for the few who decide to venture out that far; interestingly, the *exact same behavior* emerges on Minecraft anarchy servers like 2b2t! (I considered leaving out the details of which points exactly have the most hotspots to test and see if it arises the same way again, but I'm certain that it will so I'm mentioning it anyway)
Despite having no real lack of land, there's still "scarcity" in valuable land at these practically infinite worlds, due to location. 

If you're coming here because you already know about Georgist economics, you'll know where this is going already.
If not, I'll give some decent recommended reading afterwards, but the most important part are these articles: https://www.gamedeveloper.com/business/digital-real-estate-and-the-digital-housing-crisis, and https://www.gamedeveloper.com/design/land-value-tax-in-online-games-and-virtual-worlds-a-how-to-guide, both written by Lars Doucet, whose writing on Georgism, land, and land value taxes are excellent and highly recommended (if you're here from crypto, Vitalik Buterin endorsed his book!)

I'll quickly mention a few predictions this model would make for collaborative canvases with privatized land: rent seeking and speculators holding land out of use.
Rent-seeking shows up in the Million Dollar Homepage. This is even more predictable because almost all of the pixels were sold for exactly $1, only the last 1000 were auctioned (and sold for nearly 40x that price; the creator would have earned much more if he did more auctions), and what a wonderful rate of return you can get if you charge rent on something like that! One example is someone who made a 3x3 grid of buttons and charged rent for them to redirect to your website.
Interestingly, there's no space held out of use on the Million Dollar Homepage. This makes sense, though, because holding land out of use occurs when you're speculating on being able to sell at a higher price; buyers couldn't resell their pixels, so they at least had to do *something* with it, and so the whole canvas was painted.
Places like Moonplace.io on the other hand have a significant portion left empty, and if you look, they are owned, and many are owned by just the top few holders; probably speculation resulting to underdevelopment.

In general, the predictions Lars wrote for the more complicated "metaverses" play out similarly in these very simple worlds; most of them have what he described as "blood taxes", i.e. the location's value is "taxed", not by whoever's willing to pay most for it, but by whoever's willing to fight most for it.

This description of blood taxes initially seemed to me to be little more than a throwaway note, but I've found it quite useful for interpreting what land rents and land taxes even do in the first place:
Where in nature (or the rules of a synthetic world) you find blood taxes arising over some resource like land, privatizing it turns it from a burning of resources into a collection of revenue; and from there, you have a spectrum of where to direct that revenue to: between the public in the form of a land value tax, or to a private landowner in the form of land rents.

The tax for a valuable location *is always paid*, whether it's blood tax or rents to a landowner or LVT to the public. The difference is only a matter of where the tax goes to; and so as I value efficient land use (I'll leave the details as to why it incentivizes efficient land use for Lars's other works at gameofrent.com, and other Georgist writings and media) and having public goods, I favor the LVT.



So this all leads to an obvious thing to try and test with collaborative canvases: what happens when you introduce land value taxes?

How big of a deal is the land on these canvases? Well, the Million Dollar Homepage made a million dollars (and as I claimed earlier, it could evidently have made much more!), and also here's some data about r/place's 2022 round: over just 3.5 days,
10.5 million users
160 million pixel changes, at an average of 2 million pixels per hour, minus 26 million redundant changes overall
For reference, the cooldown between placing pixels was between 5 and 20 minutes, as far as I could tell, some people had lower or higher for unclear reasons.

Yes, Reddit is big, but that's still very impressive. 1/100th of that is still a lot of activity.
It's fun to wonder about what big revenue number this could create, but really, I have no idea. Thankfully, we can find out very soon!

The way I've implemented the land taxes on this is having auctions to have control over a particular pixel, with the auctions having a set interval globally.


I currently have no clue what to do for governance with respect to how to spend the revenue, so feedback on that is very appreciated. 
One thing that I will note is that there's another topic from Georgism I find quite interesting called the "Henry George Theorem": Spending revenue collected via land value taxes on public goods increases land values enough that it pays for itself (so long as it's spent nearby, evidently).

This is kinda seen in crypto on Ethereum rollups that use transaction fee revenue to fund public goods: more useful stuff to do onchain means blockspace is more valuable, which makes fees go up, and so the investment in public goods pays for itself.

On the details of governance, I'm not sure what the best path would be. I'd love to hear ideas for how this could be managed in a way that it won't be captured for rent-seeking.
For spending, as I've mentioned, invoking the Henry George Theorem to fund public goods and get a positive return is appealing.
...on that note, I don't have a frontend ready, because I have zero experience making frontends! I had some vague offers that someone could offer help, but this can tie in with this idea: have a little hackathon where if you make a good frontend you may be paid for it?
and also, personally, my attention is too divided from work and generally recovering from being burnt out and brainfog-y so I'd be able to work more on this if I could afford some time off, but I'll leave it up to the community whether to pay me from the revenue of this creation or not.



I hope you all enjoy this! I haven't put it on a testnet or mainnet yet, since I'm not sure which would be best, so I'd like some input on that, and also input on the code generally. Come chat with me in the Discord: https://discord.gg/SHKHfHsVpd

also help me come up with better names, naming things is always the most difficult for me


A bit of a footnote on details of some other design decisions:
There's another concept in Georgism that's sometimes referred to as "excess burdens come out of rents": the meaning of this being any burdens placed on the economy depress land rents. As my intention is to build something that raises money, I decided to minimize any artificial scarcity built in; so, no needing to gather resources, nearly limitless canvas, etc. so that there's minimal burdens on the economy. 
I'd personally apply this generally to design of metaverses, as well: build a world where ingame assets like houses and structures and decorations, etc. be post-scarce, not requiring going out into some world and gathering natural resources. Basically, creative mode of some sort. And, have an endless supply of land; just tax the value of a particular location. I view the best possible version of metaverses to just be an online pseudo-physical place to interact with other people. Sure, some people might enjoy grinding for resources in some games, but that seems to me to not be the point of these types of worlds

It may also be interesting to consider an option for governance to protect certain territory, exempting it from land taxes, essentially subsidizing something, maybe because it's nice art or good public information or something that's providing value.

I have also put in a basic system for private worlds where the owner can collect some or all of the land rents; I do also hope that if some metaverse system becomes vastly popular, that users can have their own bubble dimensions to retreat to from the general public world, just to reduce friction.
