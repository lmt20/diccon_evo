// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$QuestionAnswer {
  String get question => throw _privateConstructorUsedError;
  StringBuffer get answer => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QuestionAnswerCopyWith<QuestionAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionAnswerCopyWith<$Res> {
  factory $QuestionAnswerCopyWith(
          QuestionAnswer value, $Res Function(QuestionAnswer) then) =
      _$QuestionAnswerCopyWithImpl<$Res, QuestionAnswer>;
  @useResult
  $Res call({String question, StringBuffer answer});
}

/// @nodoc
class _$QuestionAnswerCopyWithImpl<$Res, $Val extends QuestionAnswer>
    implements $QuestionAnswerCopyWith<$Res> {
  _$QuestionAnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? answer = null,
  }) {
    return _then(_value.copyWith(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as StringBuffer,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionAnswerImplCopyWith<$Res>
    implements $QuestionAnswerCopyWith<$Res> {
  factory _$$QuestionAnswerImplCopyWith(_$QuestionAnswerImpl value,
          $Res Function(_$QuestionAnswerImpl) then) =
      __$$QuestionAnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String question, StringBuffer answer});
}

/// @nodoc
class __$$QuestionAnswerImplCopyWithImpl<$Res>
    extends _$QuestionAnswerCopyWithImpl<$Res, _$QuestionAnswerImpl>
    implements _$$QuestionAnswerImplCopyWith<$Res> {
  __$$QuestionAnswerImplCopyWithImpl(
      _$QuestionAnswerImpl _value, $Res Function(_$QuestionAnswerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? answer = null,
  }) {
    return _then(_$QuestionAnswerImpl(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as StringBuffer,
    ));
  }
}

/// @nodoc

class _$QuestionAnswerImpl implements _QuestionAnswer {
  const _$QuestionAnswerImpl({required this.question, required this.answer});

  @override
  final String question;
  @override
  final StringBuffer answer;

  @override
  String toString() {
    return 'QuestionAnswer(question: $question, answer: $answer)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionAnswerImpl &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.answer, answer) || other.answer == answer));
  }

  @override
  int get hashCode => Object.hash(runtimeType, question, answer);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionAnswerImplCopyWith<_$QuestionAnswerImpl> get copyWith =>
      __$$QuestionAnswerImplCopyWithImpl<_$QuestionAnswerImpl>(
          this, _$identity);
}

abstract class _QuestionAnswer implements QuestionAnswer {
  const factory _QuestionAnswer(
      {required final String question,
      required final StringBuffer answer}) = _$QuestionAnswerImpl;

  @override
  String get question;
  @override
  StringBuffer get answer;
  @override
  @JsonKey(ignore: true)
  _$$QuestionAnswerImplCopyWith<_$QuestionAnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
