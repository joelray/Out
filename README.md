Out
===

### ActionScript 3 Log Engine ###

Created by [Joel Ray](https://github.com/joelray).


### Basic Usage

<code>
Out.registerEngine(Trace.getInstance());<br/>
Out.filterLevel = Out.DEBUG;<br/>
Out.filterByEquality = false;<br/>
Out.clear();<br/>
Out.info(this, "A simple log setup!");
</code>


### Change Log ###


2011 09 25 - **r1**

* Initial build