## 0.23.0

* Support latest dependencies.
* Reintroduce custom equality for `PropertyChangeRecord` from 0.18.0.
* Update ObservableMap to notify observers about changes for all methods.

## 0.22.2

* Add `toObservableList` and `toObservableMap`, better typed versions of
  `toObservable`.

## 0.22.1+5

Fix generic type error that occurs when using ChangeNotifier with a subclass of
ChangeRecord. Previously, calling `notifyChanges()` on
`class Foo with ChangeNotifier<CustomChangeRecord> {}` would throw a type error.
Now, the `changes` stream emits a custom `ChangeRecords` class that implements
the `List` interface. This change is backwards compatible.

## 0.22.1+4

* Support Dart 2 stable.

* Bump and widen dev dependencies on build packages.

## 0.22.1+3

Update implementations of the `cast()` and the deprecated `retype()` methods.
* The `retype()` method on List and Map is deprecated and will be removed.
* The `cast()` method should do what the `retype()` method did.

## 0.22.1+2

* Widen dependency on quiver to include v0.29.

## 0.22.1+1

* Fixes for Dart2 runtime type errors.

## 0.22.1

* Added `ObservableList.castFrom`, similar to `List.castFrom`.

* Changed `ObservableList`'s `cast` and `retype` function to create a forwarding
  instance of `ObservableList` instead of an instance of `List`.

## 0.22.0

* Added `ObservableMap.castFrom`, similar to `Map.castFrom`.

* Fixed a bug where `ObservableMap`'s `cast` and `retype` function would create
  a new empty instance instead of a forwarding instance.

## 0.21.3

* Support Dart 2 collection methods where previously threw `UnimplementedError`.

## 0.21.2

* Fix `toObservable(deep: false)` to be shallow again.
* Remove use of `Maps`, for better compatibility with Dart 2.

## 0.21.1

* Updated one test to comply with Dart 2 voidness semantics.
* Fix Dart 2 runtime cast failure in `toObservable()`.
* Loosen `ObservableList.from()` to take `Iterable`, not `Iterable<T>`. This
  matches `List.from()` and avoids some unnecessary cast failures.

## 0.21.0

### Breaking Changes

Version 0.21.0 reverts to version 0.17.0+1 with fixes to support Dart 2.
Versions 0.18, 0.19, and 0.20 were not used by the package authors and
effectively unsupported. This resolves the fork that happened at version 0.18
and development can now be supported by the authors.

#### Reverted Changes

(From 0.20.1)
* Revert add `Observable<List|Set|Map>.unmodifiable` for immutable collections
* Revert add `Observable<List|Set|Map>.EMPTY` for empty immutable collections
  * This can be used as an optimization for libraries that always need to return
    an observable collection, but don't want to allocate a new instance to
    represent an empty immutable.

(From 0.20.0)
* Revert add `ObservableSet`, `SetChangeRecord`, and `SetDiffer`

(From 0.19.0)
* Revert refactor and deprecate `ObservableMap`-specific API
    * `ObservableMap` no longer emits `#keys` and `#values` change records
    * `ObservableMap.spy` is deprecated, becomes `.delegate` instead
* Revert Potentially breaking: `ObservableMap` may no longer be extended

Revert considered deprecated to be notified of `length` changes.

(From 0.18.0)
* Revert refactor and deprecate `ObservableList`-specific API
    * `ObservableList.applyChangeRecords`
    * `ObservableList.calculateChangeRecords`
    * `ObservableList.withLength`
    * `ObservableList.deliverListChanges`
    * `ObservableList.discardListChanges`
    * `ObservableList.hasListChanges`
    * `ObservableList.listChanges`
    * `ObservableList.notifyListChange`
* Revert potentially breaking: `ObservableList` may no longer be extended

Revert considered deprecated to be notified of `length`, `isEmpty` and
`isNotEmpty` `PropertyChangeRecord`s on `ObservableList`

#### Changes Applied on top of version 0.17.0+1
(With internal change numbers)

* Flip deliverChanges from `@protected` to `@visibleForTesting`. cl/147029982
* Fix a typing bug in observable when running with DDC: `ChangeRecord.NONE`
  creates a `List<ChangeRecord>`, while the call sites expect a
  `List<ListChangeRecord>` or `List<MapChangeRecord>`, respectively.
  cl/155201160
* Fix `Observable._isNotGeneric` check. cl/162282107
* Fix issue with type in deliverChanges. cl/162493576
* Stop using the comment syntax for generics. cl/163224019
* Fix ListChangeRecord's added getter. Add checks for the added and removed
  getters in listChangeTests. cl/169261086.
* Migrate observable to real generic method syntax. cl/170239122
* Fix only USES_DYNAMIC_AS_BOTTOM error in observable. cl/179946618
* Cherry pick https://github.com/dart-lang/observable/pull/46.
* Stub out Dart 2 core lib changes in ObservableMap.
* Removed `Observable{List|Map}.NONE` (not Dart2 compatible).
* Fix issue with type in `ObservableList._notifyListChange`. cl/182284033

## 0.20.4+3

* Support the latest release of `pkg/quiver` (0.27).

## 0.20.4+2

* Support the latest release of `pkg/quiver` (0.26).
* Bug fix: Some minor type fixes for strict runtimes (and Dart 2.0), namely:
  * PropertyChangeNotifier merely `extends
    ChangeNotifier` rather than `extends ChangeNotifier<PropertyChangeRecord>`.
  * Introduce new `ListChangeRecord.NONE` and `MapChangeRecord.NONE`.

## 0.20.4+1

* Support the latest release of `pkg/quiver` (0.25).

## 0.20.4

* Bug fix: Additional fix around `ObservableList.listChanges`

## 0.20.3

* Bug fix: Avoid emitting an empty list via `ObservableList.listChanges`

## 0.20.2

* Bug fix: Avoid emitting a no-op `MapChangeRecord`
* Bug fix: Restore `ObservableList.discardListChanges` functionality

## 0.20.1

* Add `Observable<List|Set|Map>.unmodifiable` for immutable collections
* Add `Observable<List|Set|Map>.EMPTY` for empty immutable collections
    * This can be used as an optimization for libraries that always
      need to return an observable collection, but don't want to
      allocate a new instance to represent an empty immutable.

## 0.20.0

* Add `ObservableSet`, `SetChangeRecord`, and `SetDiffer`

## 0.19.0

* Refactor and deprecate `ObservableMap`-specific API
    * `ObservableMap` no longer emits `#keys` and `#values` change records
    * `ObservableMap.spy` is deprecated, becomes `.delegate` instead
* Potentially breaking: `ObservableMap` may no longer be extended

It is also considered deprecated to be notified of `length` changes.

## 0.18.1

* Bug fix: Do not throw when `Observable<T>.notifyChange` is used

## 0.18.0

* Refactor and deprecate `ObservableList`-specific API
    * `ObservableList.applyChangeRecords`
    * `ObservableList.calculateChangeRecords`
    * `ObservableList.withLength`
    * `ObservableList.deliverListChanges`
    * `ObservableList.discardListChanges`
    * `ObservableList.hasListChanges`
    * `ObservableList.listChanges`
    * `ObservableList.notifyListChange`
* Potentially breaking: `ObservableList` may no longer be extended

It is also considered deprecated to be notified of `length`, `isEmpty`
and `isNotEmpty` `PropertyChangeRecord`s on `ObservableList` - in a
future release `ObservableList.changes` will be
`Stream<List<ListChangeRecord>>`.

## 0.17.0+1

* Revert `PropertyChangeMixin`, which does not work in dart2js

## 0.17.0

This is a larger change with a goal of no runtime changes for current
customers, but in the future `Observable` will [become][issue_10] a very
lightweight interface, i.e.:

```dart
abstract class Observable<C extends ChangeRecord> {
  Stream<List<C>> get changes;
}
```

[issue_10]: https://github.com/dart-lang/observable/issues/10

* Started deprecating the wide `Observable` interface
    * `ChangeNotifier` should be used as a base class for these methods:
        * `Observable.observed`
        * `Observable.unobserved`
        * `Observable.hasObservers`
        * `Observable.deliverChanges`
        * `Observable.notifyChange`
    * `PropertyChangeNotifier` should be used for these methods:
        * `Observable.notifyPropertyChange`
    * Temporarily, `Observable` _uses_ `ChangeNotifier`
        * Existing users of anything but `implements Observable` should
          move to implementing or extending `ChangeNotifier`. In a
          future release `Observable` will reduce API surface down to
          an abstract `Stream<List<C>> get changes`.
* Added the `ChangeNotifier` and `PropertyChangeNotifier` classes
    * Can be used to implement `Observable` in a generic manner
* Observable is now `Observable<C extends ChangeRecord>`
    * When passing a generic type `C`, `notifyPropertyChange` is illegal

## 0.16.0

* Refactored `MapChangeRecord`
    * Added equality and hashCode checks
    * Added `MapChangeRecord.apply` to apply a change record
* Added `MapDiffer`, which implements `Differ` for a `Map`

## 0.15.0+2

* Fix a bug in `ListDiffer` that caused a `RangeError`

## 0.15.0+1

* Fix analysis errors caused via missing `/*<E>*/` syntax in `0.15.0`

## 0.15.0

* Added the `Differ` interface, as well as `EqualityDiffer`
* Refactored list diffing into a `ListDiffer`
* Added concept of `ChangeRecord.ANY` and `ChangeRecord.NONE`
    * Low-GC ways to expression "something/nothing" changed
* Refactored `ListChangeRecord`
    * Added named constructors for common use cases
    * Added equality and hashCode checks
    * Added `ListChangeRecord.apply` to apply a change record
* Added missing `@override` annotations to satisfy `annotate_overrides`

## 0.14.0+1

* Add a missing dependency on `pkg/meta`.
